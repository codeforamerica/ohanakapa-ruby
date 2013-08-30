require 'spec_helper'

describe Ohanakapa::Client::Organizations do

  before do
    Ohanakapa.reset!
    @client = api_token_client
  end

  describe ".organizations", :vcr do
    it "returns all organizations" do
      organizations = Ohanakapa.organizations
      expect(organizations).to be_kind_of Array
    end
  end # .organizations

  describe ".organization", :vcr do
    it "returns an organization" do
      org = Ohanakapa.organization("521d32dc1974fcdb2b0008f9")
      expect(org.name).to eq "Mycological Society of San Francisco (MSSF)"
    end
  end # .organization
end
