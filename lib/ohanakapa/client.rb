require 'ohanakapa/authentication'
require 'ohanakapa/connection'
require 'ohanakapa/request'

require 'ohanakapa/client/organizations'
require 'ohanakapa/client/rate_limit'

module Ohanakapa
  class Client
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    def initialize(options={})
      options = Ohanakapa.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end

      login_and_password_from_netrc(options[:netrc])
    end

    include Ohanakapa::Authentication
    include Ohanakapa::Connection
    include Ohanakapa::Request

    include Ohanakapa::Client::Organizations
    include Ohanakapa::Client::RateLimit

  end
end
