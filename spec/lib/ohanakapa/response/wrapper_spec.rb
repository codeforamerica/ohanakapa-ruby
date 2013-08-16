require 'spec_helper'
require 'ohanakapa/response/wrapper'

describe Ohanakapa::Response::Wrapper do

  context "when using default values" do
    
    before do
      @response = Ohanakapa::Response::Wrapper.new
    end
      
    describe ".content" do
      it "is nil" do
        @response.content.should be_nil
      end
    end

  end

end
