require 'uri'
require 'faraday'
require 'faraday_middleware'
require 'convead/ext'
require 'convead/error'
require 'convead/response/raise_error'

module Convead
  class Client

    API_HOST = 'tracker.convead.io'
    EVENT_TYPES = [:link, :mailto, :file, :purchase, :view_product, :add_to_cart, :remove_from_cart, :update_cart].freeze
    ROOT_EVENT_PROPERTIES = [:visitor_uid, :guest_uid, :flow_uid, :url, :domain, :host, :path, :title, :referrer].freeze
    REQUIRED_EVENT_PROPERTIES = {
      mailto:           [:email].freeze,
      file:             [:file_url].freeze,
      view_product:     [:product_id].freeze,
      add_to_cart:      [:product_id, :qnt, :price].freeze,
      remove_from_cart: [:product_id, :qnt].freeze,
      update_cart:      [:items].freeze,
      purchase:         [:order_id, :revenue].freeze
    }

    attr_reader :app_key, :domain, :options

    def initialize(app_key, domain, options = {})
      @app_key = app_key
      @domain  = domain
      @options = options.symbolize_keys!
      @options[:adapter] ||= :net_http   
    end

    def event(type, root_params = {}, properties = {}, visitor_info = {}, attributes = {})
      type = type.to_sym
      properties.symbolize_keys!
      visitor_info.symbolize_keys!
      attributes.symbolize_keys!

      validate_event(type, root_params, properties, visitor_info, attributes)
      send_event(type, root_params, properties, visitor_info, attributes)
    end

    private

      def validate_event(type, root_params, properties, visitor_info, attributes)
        if !EVENT_TYPES.include?(type)
          raise ArgumentError.new("Unkown event #{type}")
        end
        if (root_params[:visitor_uid].to_s.strip.empty?) && (root_params[:guest_uid].to_s.strip.empty?)
          raise ArgumentError.new('visitor_uid or/and guest_uid must be present')
        end
        if invalid_root_params = root_params.keys.select{|key| !ROOT_EVENT_PROPERTIES.include?(key)}.presence
          raise ArgumentError.new("Properties '#{invalid_root_params}' are not allowed within root event parameters")
        end
        if REQUIRED_EVENT_PROPERTIES.has_key?(type) && property_names = REQUIRED_EVENT_PROPERTIES[type].select{ |p| properties[p].to_s.strip.empty? }.presence
          raise ArgumentError.new("'#{property_names}' property(s) must be present for '#{type}' event")
        end
      end

      def send_event(type, root_params, properties, visitor_info, attributes)
        url = "#{protocol}://#{domain}#{root_params[:path]}"
        params = {
          app_key:      app_key,
          type:         type,
          domain:       domain,
          host:         domain,
          url:          url,
          properties:   properties,
          visitor_info: visitor_info,
          attributes:   attributes
        }

        params.merge!(root_params)
        connection.post('/watch/event', params)
      end

      def protocol
        options[:ssl] ? 'https' : 'http'
      end

      def api_root_url
        @api_root_url ||= "#{protocol}://#{API_HOST}"
      end

      def connection
        @connection ||= Faraday.new api_root_url do |c|
          c.use     FaradayMiddleware::EncodeJson
          c.use     Convead::Response::RaiseError
          c.adapter options[:adapter]
        end
      end

  end
end
