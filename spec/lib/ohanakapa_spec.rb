require 'spec_helper'
describe Ohanakapa do
 
	after do
    Ohanakapa.reset
  end

	it 'should have a version' do
				expect(Ohanakapa::VERSION).to_not be_nil
	end

  describe ".respond_to?" do
    it "is true if method exists" do
      expect(Ohanakapa.respond_to?(:new, true)).to eq(true)
    end
  end

  describe ".new" do
    it "is a Ohanakapa::Client" do
      expect(Ohanakapa.new).to be_a Ohanakapa::Client
    end
  end

end