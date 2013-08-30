module Ohanakapa
  class Client

    # Methods for API rate limiting info
    #
    # @see http://ohanapi.herokuapp.com/api/docs
    module RateLimit

      # Get rate limit info from last response if available
      # or make a new request to fetch rate limit
      #
      # @see http://ohanapi.herokuapp.com/api/docs
      # @return [Ohanakapa::RateLimit] Rate limit info
      def rate_limit(options = {})
        return rate_limit! if last_response.nil?

        Ohanakapa::RateLimit.from_response(last_response)
      end
      alias ratelimit rate_limit


      # Refresh rate limit info by making a new request
      #
      # @see http://ohanapi.herokuapp.com/api/docs
      # @return [Ohanakapa::RateLimit] Rate limit info
      def rate_limit!(options = {})
        get "rate_limit"
        Ohanakapa::RateLimit.from_response(last_response)
      end
      alias ratelimit! rate_limit!

    end
  end
end
