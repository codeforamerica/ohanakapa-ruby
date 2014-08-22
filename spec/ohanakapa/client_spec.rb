require 'spec_helper'
require 'json'

describe Ohanakapa::Client do

  before do
    Ohanakapa.reset!
  end

  after do
    Ohanakapa.reset!
  end

  describe "module configuration" do

    before do
      Ohanakapa.reset!
      Ohanakapa.configure do |config|
        Ohanakapa::Configurable.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      Ohanakapa.reset!
    end

    it "inherits the module configuration" do
      client = Ohanakapa::Client.new
      Ohanakapa::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq "Some #{key}"
      end
    end

    describe "with class level configuration" do

      before do
        @opts = {
          :connection_options => {:ssl => {:verify => false}},
          :per_page => 40
        }
      end

      it "overrides module configuration" do
        client = Ohanakapa::Client.new(@opts)
        expect(client.per_page).to eq(40)
        expect(client.auto_paginate).to eq Ohanakapa.auto_paginate
      end

      it "can set configuration after initialization" do
        client = Ohanakapa::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end
        expect(client.per_page).to eq(40)
        expect(client.auto_paginate).to eq Ohanakapa.auto_paginate
      end

      it "masks tokens on inspect" do
        client = Ohanakapa::Client.new(:api_token => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        expect(inspected).to_not match "87614b09dd141c22800f96f11737ade5226d7ba8"
      end

    end
  end

  describe "authentication" do
    before do
      Ohanakapa.reset!
      @client = Ohanakapa.client
    end

    describe "with module level config" do
      before do
        Ohanakapa.reset!
      end
      it "sets api_token creds with .configure" do
        Ohanakapa.configure do |config|
          config.api_token     = '97b4937b385eb63d1f46'
        end
        expect(Ohanakapa.client).to be_application_authenticated
      end
      it "sets api_token creds with module methods" do
        Ohanakapa.api_token     = '97b4937b385eb63d1f46'
        expect(Ohanakapa.client).to be_application_authenticated
      end
    end

    describe "with class level config" do
      it "sets api_token creds with .configure" do
        @client.configure do |config|
          config.api_token     = '97b4937b385eb63d1f46'
        end
        expect(@client).to be_application_authenticated
      end
      it "sets api_token creds with module methods" do
        @client.api_token     = '97b4937b385eb63d1f46'
        expect(@client).to be_application_authenticated
      end
    end

    describe "when application authenticated", :vcr do
      it "makes authenticated calls" do
        client = Ohanakapa.client
        client.api_token     = '97b4937b385eb63d1f46'

        root_request = stub_get("?api_token=97b4937b385eb63d1f46")
        client.get("")
        assert_requested root_request
      end
    end
  end

  describe ".agent" do
    before do
      Ohanakapa.reset!
    end
    it "acts like a Sawyer agent" do
      expect(Ohanakapa.client.agent).to respond_to :start
    end
    it "caches the agent" do
      agent = Ohanakapa.client.agent
      expect(agent.object_id).to eq Ohanakapa.client.agent.object_id
    end
  end # .agent

  describe ".root" do
    it "fetches the API root" do
      Ohanakapa.reset!
      VCR.use_cassette 'root' do
        root = Ohanakapa.client.get '/api'
        expect(root.rels[:locations].href).to eq "http://ohana-api-demo.herokuapp.com/api/locations"
      end
    end
  end

  describe ".last_response", :vcr do
    it "caches the last agent response" do
      Ohanakapa.reset!
      client = Ohanakapa.client
      expect(client.last_response).to be_nil
      client.get "/api"
      expect(client.last_response.status).to eq 200
    end
  end # .last_response

  describe ".get", :vcr do
    before(:each) do
      Ohanakapa.reset!
    end
    it "handles query params" do
      Ohanakapa.get "/api", :foo => "bar"
      assert_requested :get, "http://ohana-api-demo.herokuapp.com/api?foo=bar"
    end
    it "handles headers" do
      request = stub_get("/search").
        with(:query => {:language => "french"}, :headers => {:accept => "text/plain"})
      Ohanakapa.get "search", :language => "french", :accept => "text/plain"
      assert_requested request
    end
  end # .get

  describe ".head", :vcr do
    it "handles query params" do
      Ohanakapa.reset!
      Ohanakapa.head "/api", :foo => "bar"
      assert_requested :head, "http://ohana-api-demo.herokuapp.com/api?foo=bar"
    end
    it "handles headers" do
      Ohanakapa.reset!
      request = stub_head("/search").
        with(:query => {:language => "french"}, :headers => {:accept => "text/plain"})
      Ohanakapa.head "search", :language => "french", :accept => "text/plain"
      assert_requested request
    end
  end # .head

  describe "when making requests" do
    before do
      Ohanakapa.reset!
      @client = Ohanakapa.client
    end
    it "Accepts application/vnd.ohanapi-v1+json by default" do
      VCR.use_cassette 'root' do
        root_request = stub_get('').
          with(:headers => {:accept => "application/vnd.ohanapi-v1+json"})
        @client.get ""
        assert_requested root_request
        expect(@client.last_response.status).to eq 200
      end
    end
    it "allows Accept'ing another api version" do
      root_request = stub_get('').
        with(:headers => {:accept => "application/vnd.ohanapi-v2+json"})
      @client.get '', :accept => "application/vnd.ohanapi-v2+json"
      assert_requested root_request
      expect(@client.last_response.status).to eq 200
    end
    it "sets a default user agent" do
      root_request = stub_get('').
        with(:headers => {:user_agent => Ohanakapa::Default.user_agent})
      @client.get ''
      assert_requested root_request
      expect(@client.last_response.status).to eq 200
    end
    it "sets a custom user agent" do
      user_agent = "Mozilla/5.0 CfA Yolo!"
      root_request = stub_get('').
        with(:headers => {:user_agent => user_agent})
      client = Ohanakapa::Client.new :user_agent => user_agent
      client.get ''
      assert_requested root_request
      expect(client.last_response.status).to eq 200
    end
    it "sets a proxy server" do
      Ohanakapa.configure do |config|
        config.proxy = 'http://proxy.example.com:80'
      end
      conn = Ohanakapa.client.send(:agent).instance_variable_get(:"@conn")
      expect(conn.proxy[:uri].to_s).to eq 'http://proxy.example.com'
    end
  end

  describe "auto pagination", :vcr do
    before do
      Ohanakapa.reset!
      Ohanakapa.configure do |config|
        config.auto_paginate = true
        config.per_page = 2
      end
    end

    after do
      Ohanakapa.reset!
    end

    it "fetches all the pages" do
      url = 'search?keyword=food'
      Ohanakapa.client.paginate(url)
      assert_requested :get, ohana_url("#{url}&per_page=2")
      (2..4).each do |i|
        assert_requested :get, ohana_url("#{url}&per_page=2&page=#{i}")
      end
    end
  end

  context "error handling" do
    before do
      Ohanakapa.reset!
      VCR.turn_off!
    end

    after do
      VCR.turn_on!
    end

    it "raises on 404" do
      stub_get('/booya').to_return(:status => 404)
      expect { Ohanakapa.get('booya') }.to raise_error Ohanakapa::NotFound
    end

    it "raises on 500" do
      stub_get('/boom').to_return(:status => 500)
      expect { Ohanakapa.get('boom') }.to raise_error Ohanakapa::InternalServerError
    end

    it "includes a message" do
      stub_get('/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "No location found"}.to_json
      begin
        Ohanakapa.get('boom')
      rescue Ohanakapa::UnprocessableEntity => e
        expect(e.message).to include \
          "GET http://ohana-api-demo.herokuapp.com/api/boom: 422 - No location found"
      end
    end

    it "includes a description" do
      stub_get('/search?foo=bar').
        to_return \
        :status => 400,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:description => "Required parameters are missing."}.to_json
      begin
        Ohanakapa.get('search?foo=bar')
      rescue Ohanakapa::BadRequest => e
        expect(e.message).to include \
          "GET http://ohana-api-demo.herokuapp.com/api/search?foo=bar: 400 - Required parameters are missing."
      end
    end

    it "includes an error" do
      stub_get('/search?foo=bar').
        to_return \
        :status => 400,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:error => "bad request"}.to_json
      begin
        Ohanakapa.get('search?foo=bar')
      rescue Ohanakapa::BadRequest => e
        expect(e.message).to include \
          "GET http://ohana-api-demo.herokuapp.com/api/search?foo=bar: 400 - Error: bad request"
      end
    end

    it "includes an error" do
      stub_get('/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:error => "No location found"}.to_json
      begin
        Ohanakapa.get('boom')
      rescue Ohanakapa::UnprocessableEntity => e
        expect(e.message).to include \
          "GET http://ohana-api-demo.herokuapp.com/api/boom: 422 - Error: No location found"
      end
    end

    it "includes an error summary" do
      stub_get('/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {
          :message => "Validation Failed",
          :errors => [
            :resource => "Issue",
            :field    => "title",
            :code     => "missing_field"
          ]
        }.to_json
      begin
        Ohanakapa.get('boom')
      rescue Ohanakapa::UnprocessableEntity => e
        expect(e.message).to include \
          "GET http://ohana-api-demo.herokuapp.com/api/boom: 422 - Validation Failed"
        expect(e.message).to include "  resource: Issue"
        expect(e.message).to include "  field: title"
        expect(e.message).to include "  code: missing_field"
      end
    end

    it "knows the difference between Forbidden and rate limiting" do
      stub_get('/some/admin/stuffs').to_return(:status => 403)
      expect { Ohanakapa.get('some/admin/stuffs') }.to raise_error Ohanakapa::Forbidden

      stub_get('/organizations').to_return \
        :status => 403,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:description => "Rate limit exceeded"}.to_json
      expect { Ohanakapa.get('organizations') }.to raise_error Ohanakapa::TooManyRequests
    end
  end
end
