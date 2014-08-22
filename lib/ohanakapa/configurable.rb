module Ohanakapa

  # Configuration options for {Client}, defaulting to values
  # in {Default}
  module Configurable
    # @!attribute api_endpoint
    #   @return [String] Base URL for API requests. default: http://ohanapi.herokuapp.com/api/
    # @!attribute auto_paginate
    #   @return [Boolean] Auto fetch next page of results until rate limit reached
    # @!attribute [w] api_token
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
    #   @return [Faraday::Builder or Faraday::RackBuilder] Configure middleware for Faraday
    # @!attribute per_page
    #   @return [String] Configure page size for paginated results. API default: 30
    # @!attribute proxy
    #   @see https://github.com/lostisland/faraday
    #   @return [String] URI for proxy server
    # @!attribute user_agent
    #   @return [String] Configure User-Agent header for requests.

    attr_accessor :api_endpoint, :auto_paginate, :connection_options,
                  :default_media_type, :middleware, :proxy,
                  :user_agent
    attr_writer :api_token

    class << self

      # List of configurable keys for {Ohanakapa::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
          :api_endpoint,
          :auto_paginate,
          :api_token,
          :connection_options,
          :default_media_type,
          :middleware,
          :proxy,
          :user_agent
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

    private

    def options
      Hash[Ohanakapa::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end
  end
end
