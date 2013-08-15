require 'spec_helper'

describe Ohanakapa::Client do

  describe ".rate_limit" do

=begin
     before(:each) do

      client = Ohanakapa::Client.new
      client.api_token = "d234gasd56567"
      client.get "http://ohanapi.herokuapp.com/api/rate_limit?api_token=d234gasd56567"
      VCR.use_cassette 'rate_limit' do
        rate = client.rate_limit

        expect(rate.limit).to be_kind_of Fixnum
        expect(rate.remaining).to be_kind_of Fixnum
      end
    end
=end

    xit "gets the ratelimit-limit from the header" do
      expect(@client.ratelimit).to eq(5000)
    end

    xit "gets the ratelimit-remaining using header" do
      expect(@client.ratelimit_remaining).to eq(5000)
    end

  end

end
