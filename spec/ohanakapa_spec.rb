require 'spec_helper'

describe Ohanakapa do
	before do
    Ohanakapa.reset!
  end

  after do
    Ohanakapa.reset!
  end

  it "sets defaults" do
    Ohanakapa::Configurable.keys.each do |key|
      expect(Ohanakapa.instance_variable_get(:"@#{key}")).to eq Ohanakapa::Default.send(key)
    end
  end

  describe ".client" do
    it "creates an Ohanakapa::Client" do
      expect(Ohanakapa.client).to be_kind_of Ohanakapa::Client
    end
    it "caches the client when the same options are passed" do
      expect(Ohanakapa.client).to eq Ohanakapa.client
    end
    it "returns a fresh client when options are not the same" do
      client = Ohanakapa.client
      Ohanakapa.api_token = '87614b09dd141c22800f96f11737ade5' #fake token
      client_two = Ohanakapa.client
      client_three = Ohanakapa.client
      expect(client).to_not eq client_two
      expect(client_three).to eq client_two
    end
  end

  describe ".configure" do
    Ohanakapa::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Ohanakapa.configure do |config|
          config.send("#{key}=", key)
        end
        expect(Ohanakapa.instance_variable_get(:"@#{key}")).to eq key
      end
    end
  end

end