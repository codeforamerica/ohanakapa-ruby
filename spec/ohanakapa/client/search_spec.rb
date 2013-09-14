require 'spec_helper'

describe Ohanakapa::Client::Search do

  before do
    Ohanakapa.reset!
    @client = Ohanakapa::Client.new
  end

  describe ".search" do

    it "searches for keyword 'market'", :vcr do
      results = @client.search("search", :keyword => 'market')

      assert_requested :get, ohana_url('/search?keyword=market')
      expect(results.count).to be_kind_of Fixnum
      expect(results).to be_kind_of Array
    end

    it "searches for location 'san mateo, ca'", :vcr do
      results = @client.search("search", :location => 'san mateo, ca')

      assert_requested :get, ohana_url('/search?location=san%20mateo%2C%20ca')
      expect(results.count).to be_kind_of Fixnum
      expect(results).to be_kind_of Array
    end

    it "searches for keyword 'food' and language 'Spanish'", :vcr do
      results = @client.search("search", :keyword => 'food', \
        :language  => 'spanish')

      assert_requested :get, ohana_url('/search?keyword=food&language=spanish')
      expect(results.count).to be_kind_of Fixnum
      expect(results).to be_kind_of Array
    end
  end # .search

end
