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

      response = @client.query({:keyword=>"market"})
      expect(response.length).to eq(22)
      expect(response.first["_id"]).to eq("51a9fd0028217f8977000023")
    end

    it "searches for keyword 'park'" do
      stub_get("http://ohanapi.herokuapp.com/api/search?keyword=park").
        to_return(json_response("query_keyword_park.json"))

      response = @client.query({:keyword=>"park"})
      expect(response.length).to eq(30)
      expect(response.first["_id"]).to eq("51a9fd0028217f8977000014")
    end

  end

end
