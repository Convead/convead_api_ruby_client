module Convead
  module Response
    class RaiseError < Faraday::Response::Middleware

      def on_complete(response)
        status = response.status.to_i
        if status != 200
          klass = Convead::Error::APIError.errors[status] || Convead::Error::APIError
          raise klass.new("Server responded with status #{status}", status, response)
        end
      end

    end
  end
end
