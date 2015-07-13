require 'spec_helper'

describe Ohanakapa::Client::Organizations do
  before do
    Ohanakapa.reset!
    @client = api_token_client
  end

  describe '.organizations', :vcr do
    it 'returns all organizations' do
      organizations = Ohanakapa.organizations

      expect(organizations).to be_kind_of Array
    end
  end # .organizations

  describe '.organization', :vcr do
    it 'returns an organization' do
      org = Ohanakapa.organization('1')

      expect(org.name).to eq 'Peninsula Family Service'
    end
  end # .organization
end
