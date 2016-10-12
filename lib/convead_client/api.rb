require 'uri'
require 'httparty'

module ConveadClient
  class Api
    include HTTParty

    attr_reader :app_key

    def initialize(app_key)
      @app_key = app_key
    end

    def order_delete(order_id)
      send("accounts/orders/#{order_id}", 'DELETE')
    end

    def order_set_state(order_id, state='')
      send("accounts/orders/#{order_id}", 'POST', {state: state})
    end

    def send(path, method='GET', params={})
      request_url = "#{ConveadClient.api_url}/api/v1/#{@app_key}/#{path}"
      request(request_url, method, params = {})
    end

    private

    def request(request_url, method, params={})
      method = method.to_s.downcase
      response = self.class.send(method, request_url, body: params)
      status = response.code
      if status != 200
        raise ConveadClient::APIError.new(status, response, params)
      end 
      response
    end

  end
end