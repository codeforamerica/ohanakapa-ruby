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
      query[:response].length.should eq(22)
      query[:response].first["_id"].should eq("51a9fd0028217f8977000023")
    end

    it "searches for keyword 'asdf'" do
      stub_get("http://ohanapi.herokuapp.com/api/search?keyword=asdf").
        to_return(json_response("query_keyword_asdf.json"))

      query = @client.query({:keyword=>"asdf"})
      query[:response].length.should eq(0)
      query[:count].should eq(0)
    end

    it "searches for location '94401'" do
      stub_get("http://ohanapi.herokuapp.com/api/search?location=94401").
        to_return(json_response("query_location_94401.json"))

      query = @client.query({:location=>"94401"})
      query[:response].length.should eq(30)
      query[:response].first["_id"].should eq("51a9fd0328217f89770001fc")
    end
=begin
    it "searches for empty keyword and location '94401'" do
      stub_get("http://ohanapi.herokuapp.com/api/search?location=94401").
        to_return(json_response("query_location_94401.json"))

      response = @client.query({:location=>"94401"})
      expect(response.length).to eq(30)
      expect(response.first["_id"]).to eq("51a9fd0328217f89770001fc")
    end
=end

  end

end
