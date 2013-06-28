require 'helper'
require 'ohanakapa/client/query'

describe Ohanakapa::Client::Query do

  before do
    @client = Ohanakapa::Client.new
  end

  describe ".query" do

    it "searches for keyword 'market'" do
      stub_get("http://ohanapi.herokuapp.com/api/search?keyword=market").
        to_return(json_response("query_keyword_market.json"))

      query = @client.query({:keyword=>"market"})
      query.content.length.should eq(30)
      @client.pagination.items_current.should eq(30)
      @client.pagination.items_total.should eq(43)
      query.content.first["_id"].should eq("51a9fd0028217f8977000023")
    end

    it "searches for keyword 'asdf'" do
      stub_get("http://ohanapi.herokuapp.com/api/search?keyword=asdf").
        to_return(json_response("query_keyword_asdf.json"))

      query = @client.query({:keyword=>"asdf"})
      query.content.length.should eq(0)

      @client.pagination.current.should eq(1)
      @client.pagination.next.should be_nil
      @client.pagination.prev.should be_nil
      @client.pagination.pages_total.should eq(1)
      @client.pagination.items_per_page.should eq(30)
      @client.pagination.items_current.should eq(0)
      @client.pagination.items_total.should eq(0)
    end

    it "searches for location '94401'" do
      stub_get("http://ohanapi.herokuapp.com/api/search?location=94401").
        to_return(json_response("query_location_94401.json"))

      query = @client.query({:location=>"94401"})
      query.content.length.should eq(30)
      @client.pagination.items_current.should eq(30)
      @client.pagination.items_total.should eq(48)
      query.content.first["_id"].should eq("51a9fd0328217f89770001fc")
    end

    it "searches for empty keyword and location '94401'" do
      stub_get("http://ohanapi.herokuapp.com/api/search?location=94401").
        to_return(json_response("query_location_94401.json"))

      query = @client.query({:keyword=>nil,:location=>"94401"})
      query.content.length.should eq(30)
      @client.pagination.items_current.should eq(30)
      @client.pagination.items_total.should eq(48)
      query.content.first["_id"].should eq("51a9fd0328217f89770001fc")
    end

    it "searches for empty location and keyword 'market'" do
      stub_get("http://ohanapi.herokuapp.com/api/search?keyword=market").
        to_return(json_response("query_keyword_market.json"))

      query = @client.query({:keyword=>"market",:location=>nil})
      query.content.length.should eq(30)
      @client.pagination.items_current.should eq(30)
      @client.pagination.items_total.should eq(43)
      query.content.first["_id"].should eq("51a9fd0028217f8977000023")
    end
=begin
    describe ".empty_set" do

      it "returns empty response set"
        query = @client.empty_set
        query.content.length.should eq(0)
        @client.pagination.items_current.should eq(0)
        @client.pagination.items_total.should eq(0)
      end

    end
=end
  end

end
