require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'json'
require 'ohanakapa'
require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!(:allow => 'coveralls.io')

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

require 'vcr'
VCR.configure do |c|
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<<API_TOKEN>>") do
      ENV['OHANAKAPA_TEST_API_TOKEN']
  end
  c.default_cassette_options = {
    :serialize_with             => :json,
    :preserve_exact_body_bytes  => true,
    :decode_compressed_response => true,
    :record                     => ENV['TRAVIS'] ? :none : :once
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

def test_api_token
  ENV.fetch 'OHANAKAPA_TEST_API_TOKEN'
end

def stub_delete(url)
  stub_request(:delete, ohana_url(url))
end

def stub_get(url)
  stub_request(:get, ohana_url(url))
end

def stub_head(url)
  stub_request(:head, ohana_url(url))
end

def stub_patch(url)
  stub_request(:patch, ohana_url(url))
end

def stub_post(url)
  stub_request(:post, ohana_url(url))
end

def stub_put(url)
  stub_request(:put, ohana_url(url))
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def json_response(file)
  {
    :body => fixture(file),
    :headers => {
      :content_type => 'application/json; charset=utf-8'
    }
  }
end

def ohana_url(url)
  url =~ /^http/ ? url : "http://ohanapi.herokuapp.com/api#{url}"
end

def api_token_client
  Ohanakapa::Client.new(:api_token => test_api_token)
end