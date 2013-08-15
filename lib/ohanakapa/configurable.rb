module Ohanakapa

  # Configuration options for {Client}, defaulting to values
  # in {Default}
  module Configurable
    # @!attribute [w] access_token
    #   @see http://developer.github.com/v3/oauth/
    #   @return [String] OAuth2 access token for authentication
    # @!attribute api_endpoint
    #   @return [String] Base URL for API requests. default: https://api.github.com/
    # @!attribute auto_paginate
    #   @return [Boolean] Auto fetch next page of results until rate limit reached
    # @!attribute client_id
    #   @see http://developer.github.com/v3/oauth/
    #   @return [String] Configure OAuth app key
    # @!attribute [w] client_secret
    #   @see http://developer.github.com/v3/oauth/
    #   @return [String] Configure OAuth app secret
    # @!attribute default_media_type
    #   @see http://developer.github.com/v3/media/
    #   @return [String] Configure preferred media type (for API versioning, for example)
    # @!attribute connection_options
    #   @see https://github.com/lostisland/faraday
    #   @return [Hash] Configure connection options for Faraday
    # @!attribute login
    #   @return [String] GitHub username for Basic Authentication
    # @!attribute middleware
    #   @see https://github.com/lostisland/faraday
    #   @return [Faraday::Builder] Configure middleware for Faraday
    # @!attribute netrc
    #   @return [Boolean] Instruct Octokit to get credentials from .netrc file
    # @!attribute netrc_file
    #   @return [String] Path to .netrc file. default: ~/.netrc
    # @!attribute [w] password
    #   @return [String] GitHub password for Basic Authentication
    # @!attribute per_page
    #   @return [String] Configure page size for paginated results. API default: 30
    # @!attribute proxy
    #   @see https://github.com/lostisland/faraday
    #   @return [String] URI for proxy server
    # @!attribute user_agent
    #   @return [String] Configure User-Agent header for requests.
    # @!attribute web_endpoint
    #   @return [String] Base URL for web URLs. default: https://github.com/

    attr_accessor :api_endpoint, :auto_paginate, :default_media_type, :connection_options,
                  :middleware, :per_page, :proxy, :api_token, :user_agent, :web_endpoint

    class << self

      # List of configurable keys for {Octokit::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
          :api_endpoint,
          :auto_paginate,
          :connection_options,
          :default_media_type,
          :middleware,
          :per_page,
          :proxy,
          :api_token,
          :user_agent,
          :web_endpoint
        ]
      end
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    # Reset configuration options to default values
    def reset!
      Ohanakapa::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Ohanakapa::Default.options[key])
      end
      self
    end
    alias setup reset!

    def api_endpoint
      File.join(@api_endpoint, "")
    end

    # Base URL for generated web URLs
    def web_endpoint
      File.join(@web_endpoint, "")
    end

    private

    def options
      Hash[Ohanakapa::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end
  end
end
