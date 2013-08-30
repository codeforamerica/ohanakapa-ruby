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

end
