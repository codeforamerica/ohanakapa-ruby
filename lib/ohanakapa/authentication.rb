module Ohanakapa

  # Authentication methods for {Ohanakapa::Client}
  module Authentication

    # Indicates if the client has Application
    # api_token credentials to make anonymous
    # requests at a higher rate limit
    #
    # @see http://ohanapi.herokuapp.com/api/docs
    # @return Boolean
    def application_authenticated?
      !!application_authentication
    end

    private

    def application_authentication
      if @api_token
        { :api_token => @api_token }
      end
    end

  end
end
