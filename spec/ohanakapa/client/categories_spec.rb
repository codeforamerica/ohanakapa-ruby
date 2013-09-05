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

  describe ".category", :vcr do
    it "returns a category" do
      cat = Ohanakapa.category("5227d9c4560873d01c00002b")
      expect(cat.name).to eq "Independent Living"
    end

    it "returns the category's parent's name" do
      cat = Ohanakapa.category("5227d9c4560873d01c00002b")
      expect(cat.parent_name).to eq "Long-Term Housing"
    end
  end # .category

end
