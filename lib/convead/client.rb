require 'uri'
require 'faraday'
require 'faraday_middleware'
require 'convead/ext'
require 'convead/error'
require 'convead/response/raise_error'

module Convead
  class Client

    API_HOST = 'tracker.convead.io'
    EVENT_TYPES = [:link, :mailto, :file, :purchase, :view, :submit, :close].freeze
    ROOT_EVENT_PROPERTIES = [:visitor_uid, :guest_uid, :flow_uid, :path, :title, :revenue , :order_id, :items, :widget_id, :referrer, :key_page_id].freeze
    REQUIRED_EVENT_PROPERTIES = {
      general: [:path].freeze,
      mailto:  [:email].freeze,
      file:    [:file_url].freeze
    }
    
    attr_reader :app_key, :domain, :options

    def initialize(app_key, domain, options = {})
      @app_key = app_key
      @domain  = domain
      @options = options.symbolize_keys!
      @options[:adapter] ||= :net_http   
    end

    def event(type, properties, visitor_info = {})
      type = type.to_sym
      properties.symbolize_keys!
      visitor_info.symbolize_keys!

      validate_event(type, properties, visitor_info)
      send_event(type, properties, visitor_info)
    end

    private

      def validate_event(type, properties, visitor_info)
        if !EVENT_TYPES.include?(type)
          raise ArgumentError.new("Unkown event #{type}")
        end
        if (properties[:visitor_uid].to_s.strip.empty?) && (properties[:guest_uid].to_s.strip.empty?)
          raise ArgumentError.new('visitor_uid or/and guest_uid must be present')
        end
        if property_name = REQUIRED_EVENT_PROPERTIES[:general].detect{ |p| properties[p].to_s.strip.empty? }
          raise ArgumentError.new("'#{property_name}' property must be present")
        end
        if REQUIRED_EVENT_PROPERTIES.has_key?(type) && property_name = REQUIRED_EVENT_PROPERTIES[type].detect{ |p| properties[p].to_s.strip.empty? }
          raise ArgumentError.new("'#{property_name}' property must be present for '#{type}' event")
        end
        unless properties[:path] =~ /^\/.*/
          raise ArgumentError.new("path must be relative, e.g.: '/' or '/foo/bar'")
        end
      end

      def send_event(type, properties, visitor_info)
        url = "#{protocol}://#{domain}#{properties[:path]}"
        params = {
          app_key:      app_key,
          type:         type,
          domain:       domain,
          host:         domain,
          url:          url,
          visitor_info: visitor_info
        }
        ROOT_EVENT_PROPERTIES.each do |property_name|
          params[property_name] = properties.delete(property_name)
        end
        params[:properties] = properties

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
