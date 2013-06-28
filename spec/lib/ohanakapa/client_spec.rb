require 'spec_helper'
require 'ohanakapa/client'
require 'ohanakapa/error'

describe Ohanakapa::Client do

  before do
    #File.chmod 0600, "spec/fixtures/.netrc"
    @client = Ohanakapa::Client.new
    #Ohanakapa.reset
  end

  describe "error handling" do

    it "searchs for id that does not exist and returns not found error" do
      stub_get("http://ohanapi.herokuapp.com/api/organizations/519c44065634241897000023").
        to_return(json_response("error_not_found.json"))

      expect {@client.organization("519c44065634241897000023")}.to raise_error(Ohanakapa::NotFound)
    end
  end

=begin

    it "displays bad request error" 
# TODO implement search so bad request error can be tested
    do
      stub_get("http://ohanapi.herokuapp.com/api/search?id=519c44065634241897000023").
        to_return(json_response("error_bad_request.json"))

      #response = @client.search({id:"519c44065634241897000023"})
      #expect(response["error"]).to eq("bad_request")
    end



  describe "ratelimit" do

    before(:each) do
      stub_request(:get, "https://api.github.com/rate_limit").
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
=end

end
