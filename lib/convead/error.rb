module Convead
  class Error < StandardError
    
    class APIError < self
      attr_reader :code, :response

      def self.errors
        @errors ||= {
          400 => Convead::Error::BadRequest,
          404 => Convead::Error::ResourceNotFound,
          500 => Convead::Error::InternalServerError,
          502 => Convead::Error::BadGateway,
          503 => Convead::Error::ServiceUnavailable,
          504 => Convead::Error::GatewayTimeout
        }
      end

      def initialize(message = '', code = nil, response = nil)
        super message
        @response = response
        @code = code
      end
    end

    class ClientError < APIError; end

    class BadRequest < ClientError; end

    class ResourceNotFound < ClientError; end

    class ServerError < APIError; end

    class InternalServerError < ServerError; end

    class BadGateway < ServerError; end

    class ServiceUnavailable < ServerError; end

    class GatewayTimeout < ServerError; end

  end
end