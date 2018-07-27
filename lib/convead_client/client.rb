require 'uri'
require 'httparty'

module ConveadClient
  class Client
    include HTTParty

    DEFAULT_ENDPOINT = 'https://tracker.convead.io/watch/event'.freeze

    attr_reader :app_key, :domain, :options

    def initialize(app_key, domain, options = {})
      @app_key = app_key
      @domain  = domain.downcase
      @options = options.stringify_keys
    end

    # Send event to Convead API
    # Raise ConveadClient::APIError if responce is not OK
    def event(type, root_params = {}, properties = {}, visitor_info = {}, attributes = {})
      send_event(type, root_params, properties, visitor_info, attributes)
    end

    private

    def send_event(type, root_params, properties, visitor_info, attributes)
      root_params = root_params.stringify_keys
      properties = properties.stringify_keys
      visitor_info = visitor_info.stringify_keys
      attributes = attributes.stringify_keys   
      
      url = "#{protocol}://#{domain}#{root_params['path']}"
      params = {
        'app_key' => app_key,
        'type' => type,
        'domain' => domain,
        'host' => domain,
        'url' => url,
        'properties' => properties,
        'visitor_info' => visitor_info,
        'attributes' => attributes,
      }

      params.merge!(root_params)
      params = {
        'app_key' => params['app_key'],
        'visitor_uid' => params['visitor_uid'],
        'guest_uid' => params['guest_uid'],
        'data' => params.to_json,
      }
      
      request(params)
    end

    def protocol
      options['ssl'] ? 'https' : 'http'
    end

    def endpoint
      options['endpoint'] || DEFAULT_ENDPOINT 
    end

    def request(params={})
      response = self.class.post(endpoint, body: params)
      status = response.code
      if status != 200
        raise ConveadClient::APIError.new(status, response, params)
      end 
    end
  end
end
