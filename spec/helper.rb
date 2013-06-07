require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'ohanakapa'
require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!(:allow => 'coveralls.io')

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def a_delete(url)
  a_request(:delete, ohana_url(url))
end

def a_get(url)
  a_request(:get, ohana_url(url))
end

def a_patch(url)
  a_request(:patch, ohana_url(url))
end

def a_post(url)
  a_request(:post, ohana_url(url))
end

def a_put(url)
  a_request(:put, ohana_url(url))
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
  if url =~ /^http/
    url
  elsif @client && @client.authenticated?
    "https://#{@client.login}:#{@client.password}@ohanapi.herokuapp.com/api#{url}"
  else
    "https://ohanapi.herokuapp.com/api#{url}"
  end
end
