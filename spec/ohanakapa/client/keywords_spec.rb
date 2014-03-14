require 'spec_helper'

describe Ohanakapa::Client::Categories do

  before do
    Ohanakapa.reset!
    @client = api_token_client
  end

  describe ".add_keywords_to_a_service", :vcr do
    it "adds keywords to a given service" do
      service_id = "521d339f1974fcdb2b00573e"
      keywords = ['apitest', 'sandbox']
      service = @client.add_keywords_to_a_service(service_id, keywords)
      expect(service.name).to match /CalFresh Application Assistance/
      assert_requested :post, ohana_url("/services/#{service_id}/keywords?api_token=#{test_api_token}&keywords%5B0%5D=apitest&keywords%5B1%5D=sandbox")
    end
  end # .add_keywords_to_a_service

end
