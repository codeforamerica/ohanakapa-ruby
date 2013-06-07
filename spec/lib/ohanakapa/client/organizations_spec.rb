require 'helper'

describe Ohanakapa::Client::Organizations do

  before do
    @client = Ohanakapa::Client.new
  end

  describe ".organizations" do

    it "returns all organizations" do
      stub_get("http://ohanapi.herokuapp.com/api/organizations").
        to_return(json_response("organizations.json"))
      organizations = @client.organizations
      expect(organizations.first[1][0]["_id"]).to eq("51a9fd0328217f89770001b2")
    end

  end

  describe ".organization" do

    it "returns organization details based on an id" do
      stub_get("http://ohanapi.herokuapp.com/api/organizations/51a9fd0328217f89770001b2").
        to_return(json_response("organization.json"))
      organization = @client.organization("51a9fd0328217f89770001b2")
      expect(organization.first[1]["_id"]).to eq("51a9fd0328217f89770001b2")
    end

  end

end
