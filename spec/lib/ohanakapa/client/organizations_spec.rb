require 'spec_helper'

describe Ohanakapa::Client::Organizations do

  before do
    Ohanakapa.reset!
    @client = api_token_client
  end

  describe ".organizations", :vcr do

    it "returns all organizations" do
      organizations = @client.organizations
      expect(organizations.content).to be_kind_of Array

      # TODO figure out why line below fails
      # the following generates error 'expected to execute 1 time but it executed 0 times'
      #assert_requested :get, ohana_url("/organizations")
    end

  end # .organizations

  describe ".organization", :vcr do
    it "returns an organization" do
      organization = @client.organization("51d5b18ca4a4d8b01b3e4477")
      expect(organization.content.name).to eq "Friends of the Belmont Library"

      # TODO figure out why line below fails
      # the following generates error 'expected to execute 1 time but it executed 0 times'
      #assert_requested :get, ohana_url("/organizations/51d5b18ca4a4d8b01b3e4477")
    end

    it "returns not found error because organization id is invalid" do
      expect {@client.organization("asdf")}.to raise_error(Ohanakapa::NotFound)
    end

  end # .organization

  describe ".nearby", :vcr do
    it "returns organizations nearby to an organization" do
      nearbys = @client.nearby("51d5b18ca4a4d8b01b3e4477")
      expect(nearbys.content).to be_kind_of Array
      expect(nearbys.content.first.name).to eq "Belmont Library"

      # TODO figure out why line below fails
      # the following generates error 'expected to execute 1 time but it executed 0 times'
      #assert_requested :get, ohana_url("/organizations/51d5b18ca4a4d8b01b3e4477/nearby")
    end

  end # .nearby

end
