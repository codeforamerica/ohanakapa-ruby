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
      loc = Ohanakapa.location("1")
      expect(loc.name).to eq "San Mateo Example Location"
    end
  end # .location

  describe ".nearby", :vcr do
    it "returns locations near the queried location" do
      nearbys = Ohanakapa.nearby("2")
      assert_requested :get, ohana_url("/locations/2/nearby")
      expect(nearbys).to be_kind_of Array
      expect(nearbys.first.name).to eq "Fair Oaks Branch"
    end
  end # .nearby

  describe ".update_location", :vcr do
    it "updates a location's attributes" do
      location = @client.update_location("2",
        hours: "Monday-Thursday, 10-7; Friday, 10-6")
      expect(location.hours).to eq "Monday-Thursday, 10-7; Friday, 10-6"
      assert_requested :put, ohana_url("/locations/#{location.id}?api_token=#{test_api_token}&hours=Monday-Thursday, 10-7; Friday, 10-6")
    end
  end # .update_location

end
