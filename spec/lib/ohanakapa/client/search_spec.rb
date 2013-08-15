require 'spec_helper'
require 'ohanakapa/client/search'

describe Ohanakapa::Client::Search do

  before do
    Ohanakapa.reset!
    @client = api_token_client
  end

  describe ".search" do

    it "searches for keyword 'market'", :vcr do
      results = @client.search :keyword => 'market', \
        :sort  => 'name',
        :order => 'asc'

      # TODO figure out why line below fails
      #assert_requested :get, ohana_url('/search?keyword=market&sort=name&order=asc')
      expect(results.response.count).to be_kind_of Fixnum
      expect(results.response).to be_kind_of Array
    end

    it "searches for keyword 'asdf'", :vcr do
      results = @client.search :keyword => 'asdf', \
        :sort  => 'name',
        :order => 'asc'

      # TODO figure out why line below fails
      #assert_requested :get, ohana_url('/search?keyword=asdf&sort=name&order=asc')
      expect(results.response.count).to eq(0)
    end

    it "searches for location 'san mateo, ca'", :vcr do
      results = @client.search :location => 'san mateo, ca', \
        :sort  => 'name',
        :order => 'asc'

      # TODO figure out why line below fails
      #assert_requested :get, ohana_url('/search?location=san%20mateo%2C%20ca&sort=name&order=asc')
      expect(results.response.count).to be_kind_of Fixnum
      expect(results.response).to be_kind_of Array
    end

    it "searches for location '94401'", :vcr do
      results = @client.search :location => '94401', \
        :sort  => 'name',
        :order => 'asc'

      # TODO figure out why line below fails
      #assert_requested :get, ohana_url('/search?location=94401&sort=name&order=asc')
      expect(results.response.count).to be_kind_of Fixnum
      expect(results.response).to be_kind_of Array
    end

    it "searches for location '1111111'", :vcr do
      expect {results = @client.search :location => '1111111', \
        :sort  => 'name',
        :order => 'asc'}.to raise_error(Ohanakapa::BadRequest)
    end

    it "searches for keyword 'food' and language 'Spanish'", :vcr do
      results = @client.search :keyword => 'food', \
        :language  => 'spanish',
        :sort  => 'name',
        :order => 'asc'

      # TODO figure out why line below fails
      #assert_requested :get, ohana_url('/search?keyword=food&language=spanish&sort=name&order=asc')
      expect(results.response.count).to be_kind_of Fixnum
      expect(results.response).to be_kind_of Array
    end


  end # .search

  describe ".empty_set" do

    it "returns empty response set", :vcr do
      query = @client.empty_set
      expect(query.response.count).to eq(0)
    end

  end # .empty_set

end
