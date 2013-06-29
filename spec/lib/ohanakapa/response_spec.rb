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
      it "is nil" do
        @response.content.should be_nil
      end
    end

  end

end
