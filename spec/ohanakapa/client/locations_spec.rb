require 'spec_helper'

describe Ohanakapa::Client::Locations do

  before do
    Ohanakapa.reset!
    @client = api_token_client
  end

  describe ".locations", :vcr do
    it "returns all locations" do
      locations = Ohanakapa.locations
      expect(locations).to be_kind_of Array
    end
  end # .locations

  describe ".location", :vcr do
    it "returns an location" do
      loc = Ohanakapa.location("521d32dc1974fcdb2b0008fa")
      expect(loc.name).to eq "Mycological Society of San Francisco (MSSF)"
    end
  end # .location

  describe ".nearby", :vcr do
    it "returns locations near the queried location" do
      nearbys = Ohanakapa.nearby("521d32dc1974fcdb2b0008fa")
      assert_requested :get, ohana_url("/locations/521d32dc1974fcdb2b0008fa/nearby")
      expect(nearbys).to be_kind_of Array
      expect(nearbys.first.name).to eq "Golden Gate Model Railroad Club"
    end
  end # .nearby

  describe ".update_location", :vcr do
    it "updates a location's attributes" do
      location = @client.update_location("521d33a01974fcdb2b0036a9", :kind => "entertainment")
      expect(location.kind).to eq "Entertainment"
      assert_requested :put, ohana_url("/locations/#{location.id}?api_token=5f996ce5c431a14c99419116a50a6b62&kind=entertainment")
    end
  end # .update_location

end
