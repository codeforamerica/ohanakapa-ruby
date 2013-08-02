module Ohanakapa
  module Authentication

    def unauthed_rate_limited?
      api_token
    end

    def unauthed_rate_limit_params
      { :api_token => api_token }
    end
  end
end
