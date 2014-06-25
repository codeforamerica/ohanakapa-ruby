module Ohanakapa
  # Custom error class for rescuing from all Ohana API errors
  class Error < StandardError

    # Returns the appropriate Ohanakapa::Error subclass based
    # on status and response message
    #
    # @param [Hash] response HTTP response
    # @return [Ohanakapa::Error]
    def self.from_response(response)
      status = response[:status].to_i
      body  = response[:body].to_s

      if klass =  case status
                  when 400 then Ohanakapa::BadRequest
                  when 401 then Ohanakapa::Unauthorized
                  when 403
                    if body =~ /rate limit exceeded/i
                      Ohanakapa::TooManyRequests
                    elsif body =~ /login attempts exceeded/i
                      Ohanakapa::TooManyLoginAttempts
                    else
                      Ohanakapa::Forbidden
                    end
                  when 404 then Ohanakapa::NotFound
                  when 406 then Ohanakapa::NotAcceptable
                  when 422 then Ohanakapa::UnprocessableEntity
                  when 500 then Ohanakapa::InternalServerError
                  when 501 then Ohanakapa::NotImplemented
                  when 502 then Ohanakapa::BadGateway
                  when 503 then Ohanakapa::ServiceUnavailable
                  end
        klass.new(response)
      end
    end

    def initialize(response=nil)
      @response = response
      super(build_error_message)
    end

    private

    def data
      @data ||=
        if (body = @response[:body]) && !body.empty?
          if body.is_a?(String) &&
            @response[:response_headers] &&
            @response[:response_headers][:content_type] =~ /json/

            Sawyer::Agent.serializer.decode(body)
          else
            body
          end
        else
          nil
        end
    end

    def response_message
      case data
      when Hash
        data[:message] || data[:description]
      when String
        data
      end
    end

    def response_error
      "Error: #{data[:error]}" if data.is_a?(Hash) && data[:error]
    end

    def response_error_summary
      return nil unless data.is_a?(Hash) && !Array(data[:errors]).empty?

      summary = "\nError summary:\n"
      summary << data[:errors].map do |hash|
        hash.map { |k,v| "  #{k}: #{v}" }
      end.join("\n")

      summary
    end

    def build_error_message
      return nil if @response.nil?

      message =  "#{@response[:method].to_s.upcase} "
      message << "#{@response[:url].to_s}: "
      message << "#{@response[:status]} - "
      message << "#{response_message}" unless response_message.nil?
      message << "#{response_error}" unless response_error.nil?
      message << "#{response_error_summary}" unless response_error_summary.nil?
      message
    end
  end

  # Raised when Ohana API returns a 400 HTTP status code
  class BadRequest < Error; end

  # Raised when Ohana API returns a 401 HTTP status code
  class Unauthorized < Error; end

  # Raised when Ohana API returns a 403 HTTP status code
  class Forbidden < Error; end

  # Raised when GitHub returns a 403 HTTP status code
  # and body matches 'rate limit exceeded'
  class TooManyRequests < Forbidden; end

  # Raised when Ohana API returns a 404 HTTP status code
  class NotFound < Error; end

  # Raised when Ohana API returns a 406 HTTP status code
  class NotAcceptable < Error; end

  # Raised when Ohana API returns a 422 HTTP status code
  class UnprocessableEntity < Error; end

  # Raised when Ohana API returns a 500 HTTP status code
  class InternalServerError < Error; end

  # Raised when Ohana API returns a 501 HTTP status code
  class NotImplemented < Error; end

  # Raised when Ohana API returns a 502 HTTP status code
  class BadGateway < Error; end

  # Raised when Ohana API returns a 503 HTTP status code
  class ServiceUnavailable < Error; end
end
