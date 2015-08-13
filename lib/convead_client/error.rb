module ConveadClient
  class Error < StandardError; end

  class APIError < Error
    attr_reader :code, :response, :request_params

    def initialize(code, response, request_params={})
      super "Convead respond with status #{code}. #{response.lines.first}"
      @response = response
      @code = code
      @request_params = request_params
    end
  end
end
