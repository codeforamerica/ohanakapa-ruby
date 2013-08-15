require 'spec_helper'
require 'ohanakapa/client'
require 'ohanakapa/error'

describe Ohanakapa::Client do

  describe "module configuration" do

    before do
      Ohanakapa.reset!
      Ohanakapa.configure do |config|
        Ohanakapa::Configurable.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      Ohanakapa.reset!
    end

    it "inherits the module configuration" do
      client = Ohanakapa::Client.new
      Ohanakapa::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq "Some #{key}"
      end
    end

    describe "with class level configuration" do

      before do
        @opts = {
          :connection_options => {:ssl => {:verify => false}},
          :per_page => 40
        }
      end

      it "overrides module configuration" do
        client = Ohanakapa::Client.new(@opts)
        expect(client.per_page).to eq 40
        expect(client.auto_paginate).to eq Ohanakapa.auto_paginate
      end

      it "can set configuration after initialization" do
        client = Ohanakapa::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end
        expect(client.per_page).to eq 40
        expect(client.auto_paginate).to eq Ohanakapa.auto_paginate
      end

      it "masks passwords on inspect" do
        client = Ohanakapa::Client.new(@opts)
        inspected = client.inspect
        expect(inspected).to_not include "il0veruby"
      end

      it "masks tokens on inspect" do
        client = Ohanakapa::Client.new(:access_token => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        expect(inspected).to_not match "87614b09dd141c22800f96f11737ade5226d7ba8"
      end

      it "masks client secrets on inspect" do
        client = Ohanakapa::Client.new(:client_secret => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        expect(inspected).to_not match "87614b09dd141c22800f96f11737ade5226d7ba8"
      end

    end
  end

end
