require 'faraday'
require 'ohanakapa/error'

module Ohanakapa
  # Faraday response middleware
  module Response

    # This class raises an Ohanakapa-flavored exception based 
    # HTTP status codes returned by the API
    class RaiseError < Faraday::Response::Middleware

      # Status code to error mappings
      # @private
      ERROR_MAP = {
        400 => Ohanakapa::BadRequest,
        401 => Ohanakapa::Unauthorized,
        403 => Ohanakapa::Forbidden,
        404 => Ohanakapa::NotFound,
        406 => Ohanakapa::NotAcceptable,
        422 => Ohanakapa::UnprocessableEntity,
        500 => Ohanakapa::InternalServerError,
        501 => Ohanakapa::NotImplemented,
        502 => Ohanakapa::BadGateway,
        503 => Ohanakapa::ServiceUnavailable
      }

      private

      def on_complete(response)
        key = response[:status].to_i
        raise ERROR_MAP[key].new(response) if ERROR_MAP.has_key? key
      end
    end
  end
end
