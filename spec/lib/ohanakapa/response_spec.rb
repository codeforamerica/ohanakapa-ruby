require 'spec_helper'
require 'ohanakapa/response'

describe Ohanakapa::Response do

  context "when using default values" do
    
    before do
      @response = Ohanakapa::Response.new
    end
      
    describe ".pagination" do
      it "is instance of Ohanakapa::Pagination" do
        @response.pagination.should be_instance_of Ohanakapa::Pagination
      end
    end

    describe ".content" do
      it "response has length of 0" do
        @response.content.should == {:response=>[]}
        @response.content[:response].length.should == 0
      end
    end

  end

end
