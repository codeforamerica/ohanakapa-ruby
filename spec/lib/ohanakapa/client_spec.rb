require 'spec_helper'
require 'ohanakapa/client'
require 'ohanakapa/error'

describe Ohanakapa::Client do

  describe "error handling" do
    before (:each) { @client = Ohanakapa::Client.new }

    it "returns not found error when search for id that does not exist" do
      stub_get("http://ohanapi.herokuapp.com/api/organizations/519c44065634241897000023").
        to_return(json_response("error_not_found.json"))

      expect {@client.organization("519c44065634241897000023")}.to raise_error(Ohanakapa::NotFound)
    end

    xit "displays bad request error" do
      stub_get("http://ohanapi.herokuapp.com/api/search?id=519c44065634241897000023").
        to_return(json_response("error_bad_request.json"))

      response = @client.search({id:"519c44065634241897000023"})
      expect(response["error"]).to eq("bad_request")
    end
  end

  describe "ratelimit" do

    before(:each) do
      Ohanakapa.api_token = "d234gasd56567"
      stub_request(:get, "http://ohanapi.herokuapp.com/api/rate_limit?api_token=d234gasd56567").
        to_return(:status => 200, :body => '', :headers =>
          { 'X-RateLimit-Limit' => 5000, 'X-RateLimit-Remaining' => 5000})
      @client = Ohanakapa::Client.new
    end

    it "gets the ratelimit-limit from the header" do
      expect(@client.ratelimit).to eq(5000)
    end

    it "gets the ratelimit-remaining using header" do
      expect(@client.ratelimit_remaining).to eq(5000)
    end
  end

end
