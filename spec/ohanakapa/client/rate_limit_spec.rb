require 'spec_helper'

describe Ohanakapa::Client do

  describe ".rate_limit" do
    it "makes a response if there is no last response" do
      client = Ohanakapa::Client.new
      VCR.use_cassette 'rate_limit' do
        rate = client.rate_limit

        expect(rate.limit).to be_kind_of Fixnum
        expect(rate.remaining).to be_kind_of Fixnum
      end
    end # .rate_limit
    it "checks the rate limit from the last response" do
      client = Ohanakapa::Client.new
      VCR.use_cassette 'root' do
        client.get("/api/")
        VCR.use_cassette 'rate_limit' do
          rate = client.rate_limit
          expect(rate.limit).to be_kind_of Fixnum
          expect(rate.remaining).to be_kind_of Fixnum
        end
      end
    end
  end

  describe ".rate_limit!" do
    it "makes a web request to check the rate limit" do
      client = Ohanakapa::Client.new
      VCR.use_cassette 'rate_limit' do
        rate = client.rate_limit!

        expect(rate.limit).to be_kind_of Fixnum
        expect(rate.remaining).to be_kind_of Fixnum
      end
    end
  end # .rate_limit!

end
