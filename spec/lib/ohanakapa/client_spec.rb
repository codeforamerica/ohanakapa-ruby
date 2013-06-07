require 'ohanakapa/client'
require 'spec_helper'

describe Ohanakapa::Client do

  before do
    #File.chmod 0600, "spec/fixtures/.netrc"
    @client = Ohanakapa::Client.new
    #Ohanakapa.reset
  end

  describe "error handling" do

    it "displays not found error" do
      stub_get("http://ohanapi.herokuapp.com/api/organizations/519c44065634241897000023").
        to_return(json_response("error_not_found.json"))

      response = @client.organization("519c44065634241897000023")
      expect(response["error"]).to eq("not_found")
    end

    it "displays bad request error" 
=begin
# TODO implement search so bad request error can be tested
    do
      stub_get("http://ohanapi.herokuapp.com/api/search?id=519c44065634241897000023").
        to_return(json_response("error_bad_request.json"))

      #response = @client.search({id:"519c44065634241897000023"})
      #expect(response["error"]).to eq("bad_request")
    end
=end

  end

end
