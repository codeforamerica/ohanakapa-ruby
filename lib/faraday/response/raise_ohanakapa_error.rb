require 'ohanakapa'
require 'faraday'
require 'multi_json'

# @api private
module Faraday
  class Response::RaiseOhanakapaError < Response::Middleware
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

    def on_complete(response)
      key = response[:status].to_i
      raise ERROR_MAP[key].new(response) if ERROR_MAP.has_key? key
    end
  end
end
