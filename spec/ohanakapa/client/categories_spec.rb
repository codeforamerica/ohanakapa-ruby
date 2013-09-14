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
      service_id = "521d339f1974fcdb2b00573e"
      cat_ids = ['52280f5c1edd37edff000001', '52280f5c1edd37edff000003']
      service = @client.replace_all_categories(service_id, cat_ids)
      expect(service.name).to match /CalFresh Application Assistance/
      assert_requested :put, ohana_url("/services/#{service_id}/categories?api_token=5f996ce5c431a14c99419116a50a6b62&category_ids%5B0%5D=52280f5c1edd37edff000001&category_ids%5B1%5D=52280f5c1edd37edff000003")
    end
  end # .replace_all_categories

end
