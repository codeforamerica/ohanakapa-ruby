require 'sawyer'
require 'ohanakapa/authentication'
require 'ohanakapa/configurable'

require 'ohanakapa/client/organizations'
require 'ohanakapa/client/search'
require 'ohanakapa/client/rate_limit'

module Ohanakapa
  class Client

    include Ohanakapa::Authentication
    include Ohanakapa::Configurable

    include Ohanakapa::Client::Organizations
    include Ohanakapa::Client::Search
    include Ohanakapa::Client::RateLimit

    # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set.new [:accept]

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      Ohanakapa::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Ohanakapa.instance_variable_get(:"@#{key}"))
      end
    end

    # Compares client options to a Hash of requested options
    #
    # @param opts [Hash] Options to compare with current client options
    # @return [Boolean]
    def same_options?(opts)
      opts.hash == options.hash
    end

    # Make a HTTP GET request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def get(url, options = {})
      request :get, url, parse_query_and_convenience_headers(options)
    end

    # Make one or more HTTP GET requests, optionally fetching
    # the next page of results from URL in Link response header based
    # on value in {#auto_paginate}.
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def paginate(url, options = {})
      opts = parse_query_and_convenience_headers(options.dup)
      if @auto_paginate || @per_page
        opts[:query][:per_page] ||=  @per_page || (@auto_paginate ? 100 : nil)
      end

      data = request(:get, url, opts)

      if @auto_paginate && data.is_a?(Array)
        while @last_response.rels[:next] && rate_limit.remaining > 0
          @last_response = @last_response.rels[:next].get
          data.concat(@last_response.data) if @last_response.data.is_a?(Array)
        end

      end

      data
    end

    # Hypermedia agent for the Ohana API
    #
    # @return [Sawyer::Agent]
    def agent
      @agent ||= Sawyer::Agent.new(api_endpoint, sawyer_options) do |http|
        http.headers[:accept] = default_media_type
        http.headers[:user_agent] = user_agent        
        if api_token_authenticated?
          http.headers["X-Api-Token"] = @api_token
        end
      end
    end

    # Fetch the root resource for the API
    #
    # @return [Sawyer::Resource]
    def root
      agent.start.data
    end

    # Response for last HTTP request
    #
    # @return [Sawyer::Response]
    def last_response
      @last_response
    end

    private

    def request(method, path, options)

      if accept = options.delete(:accept)
        options[:headers] ||= {}
        options[:headers][:accept] = accept
      end

      response = agent.call(method, URI.encode(path), options)
      @last_response = Ohanakapa::Response::Wrapper.new(response) # wrap Sawyer::Response in Ohanakapa wrapper
    end

    def sawyer_options
      opts = {
        :links_parser => Sawyer::LinkParsers::Simple.new
      }
      conn_opts = @connection_options
      conn_opts[:builder] = @middleware if @middleware
      conn_opts[:proxy] = @proxy if @proxy
      opts[:faraday] = Faraday.new(conn_opts)

      opts
    end

    def parse_query_and_convenience_headers(options)
      headers = options.fetch(:headers, {})
      CONVENIENCE_HEADERS.each do |h|
        if header = options.delete(h)
          headers[h] = header
        end
      end
      query = options.delete(:query)
      opts = {:query => options}
      opts[:query].merge!(query) if query && query.is_a?(Hash)
      opts[:headers] = headers unless headers.empty?

      opts
    end

  end
end
