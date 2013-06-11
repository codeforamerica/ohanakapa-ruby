require 'spec_helper'
require 'ohanakapa/error'

describe Ohanakapa::Client::Organizations do

  before do
    @client = Ohanakapa::Client.new
  end

  describe ".organizations" do

    it "returns all organizations" do
      stub_get("http://ohanapi.herokuapp.com/api/organizations?page=1").
        to_return(json_response("organizations.json"))
      query = @client.organizations
      query.content.length.should eq(30)
      @client.pagination.items_total.should eq(1734)
      query.content.first["_id"].should eq("51a9fd0028217f8977000002")
    end

  end

  describe ".organization" do

    it "returns organization details based on a correct id" do
      stub_get("http://ohanapi.herokuapp.com/api/organizations/51a9fd0328217f89770001b2").
        to_return(json_response("organization.json"))
      query = @client.organization("51a9fd0328217f89770001b2")
      @client.pagination.should be_nil
      query.content["_id"].should eq("51a9fd0328217f89770001b2")
    end

    it "returns organization details based on an incorrect id" do
      stub_get("http://ohanapi.herokuapp.com/api/organizations/asdf").
        to_return(json_response("error_not_found.json"))
      expect {@client.organization("asdf")}.to raise_error(Ohanakapa::NotFound)
    end

  end

end
