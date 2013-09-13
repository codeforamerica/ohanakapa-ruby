require 'ohanakapa/response/raise_error'
require 'ohanakapa/version'

module Ohanakapa

  # Default configuration options for {Client}
  module Default

    # Default API endpoint
    API_ENDPOINT = "http://ohanapi.herokuapp.com/api".freeze

    # Default User Agent header string
    USER_AGENT   = "Ohanakapa Ruby Gem #{Ohanakapa::VERSION}".freeze

    # Default media type
    MEDIA_TYPE   = "application/vnd.ohanapi-v1+json"

    # Default Faraday middleware stack
    MIDDLEWARE = Faraday::Builder.new do |builder|
      builder.use Ohanakapa::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end

    class << self

      # Configuration options
      # @return [Hash]
      def options
        Hash[Ohanakapa::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # Default API endpoint from ENV or {API_ENDPOINT}
      # @return [String]
      def api_endpoint
        ENV['OHANAKAPA_API_ENDPOINT'] || API_ENDPOINT
      end

      # Default pagination preference from ENV
      # @return [String]
      def auto_paginate
        ENV['OHANAKAPA_AUTO_PAGINATE']
      end

      # Default options for Faraday::Connection
      # @return [Hash]
      def connection_options
        {
          :headers => {
            :accept => default_media_type,
            :user_agent => user_agent
          }
        }
      end

      # Default media type from ENV or {MEDIA_TYPE}
      # @return [String]
      def default_media_type
        ENV['OHANAKAPA_DEFAULT_MEDIA_TYPE'] || MEDIA_TYPE
      end

      # Default middleware stack for Faraday::Connection
      # from {MIDDLEWARE}
      # @return [String]
      def middleware
        MIDDLEWARE
      end

      # Default proxy server URI for Faraday connection from ENV
      # @return [String]
      def proxy
        ENV['OHANAKAPA_PROXY']
      end

      # Default api token for Ohana API
      # @return [String]
      def api_token
        ENV['OHANAKAPA_API_TOKEN']
      end

      # Default User-Agent header string from ENV or {USER_AGENT}
      # @return [String]
      def user_agent
        ENV['OHANAKAPA_USER_AGENT'] || USER_AGENT
      end

    end
  end
end
