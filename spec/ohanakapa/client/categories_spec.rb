require 'spec_helper'

describe Ohanakapa::Client::Categories do

  before do
    Ohanakapa.reset!
    @client = api_token_client
  end

  describe ".categories", :vcr do
    it "returns all categories" do
      categories = Ohanakapa.categories
      expect(categories).to be_kind_of Array
    end
  end # .categories

  describe ".replace_all_categories", :vcr do
    it "replaces all categories for a service" do
      service_id = "1"
      oe_ids = ['101', '102']
      service = @client.replace_all_categories(service_id, oe_ids)
      expect(service.name).to match /Resume Workshop/
      assert_requested :put, ohana_url("/services/#{service_id}/categories?api_token=#{test_api_token}&oe_ids%5B0%5D=101&oe_ids%5B1%5D=102")
    end
  end # .replace_all_categories

end
