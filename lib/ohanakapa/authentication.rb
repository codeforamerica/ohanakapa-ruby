module Ohanakapa
  module Authentication

=begin
    def unauthed_rate_limited?
      api_token
    end

    def unauthed_rate_limit_params
      { :api_token => api_token }
    end
=end

    def api_token_authenticated?
    	!!@api_token
    end

  end
end
