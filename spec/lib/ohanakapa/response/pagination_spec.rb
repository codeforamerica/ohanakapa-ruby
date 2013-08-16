require 'spec_helper'
require 'ohanakapa/response/pagination'

describe Ohanakapa::Response::Pagination do

  context "when using default values" do
    # setup for pagination default values testing
    before do
      # default values of current page set to the first page, 
      # 30 results per page, and 0 total items
      @paginate = Ohanakapa::Response::Pagination.new
    end
      
    describe ".current" do
      it "has current page of 1" do
        @paginate.current.should == 1
      end
    end

    describe ".next" do
      it "has a nil next page" do
        @paginate.next.should be_nil
      end
    end

    describe ".prev" do
      it "has a nil previous page" do
        @paginate.prev.should be_nil
      end
    end

    describe ".items_per_page" do
      it "has 30 results per page" do
        @paginate.items_per_page.should == 30
      end
    end

    describe ".pages_total" do
      it "has 1 page total" do
        @paginate.pages_total.should == 1
      end
    end

    describe ".items_total" do
      it "has 0 total items" do
        @paginate.items_total.should == 0
      end
    end

    describe ".items_current" do
      it "has 0 items on the current page" do
        @paginate.items_current.should == 0
      end
    end

    # tests goto_page
    describe ".goto_page(0)" do
      it "sets page to invalid value below range" do
        @paginate.goto_page(0).should eq(false)
        @paginate.current.should == 1
        @paginate.items_current.should == 0
        @paginate.next.should be_nil
        @paginate.prev.should be_nil
      end
    end

    describe ".goto_page(1)" do
      it "sets page to valid value" do
        @paginate.goto_page(1).should eq(true)
        @paginate.current.should == 1
        @paginate.items_current.should == 0
        @paginate.next.should be_nil
        @paginate.prev.should be_nil
      end
    end

    describe ".goto_page(2)" do
      it "sets page to invalid value above range" do
        @paginate.goto_page(2).should eq(false)
        @paginate.current.should == 1
        @paginate.items_current.should == 0
        @paginate.next.should be_nil
        @paginate.prev.should be_nil
      end
    end

    # tests prev_page
    describe ".prev_page" do
      it "sets page to invalid value below range" do
        @paginate.prev_page.should eq(false)
        @paginate.current.should == 1
        @paginate.items_current.should == 0
        @paginate.next.should be_nil
        @paginate.prev.should be_nil
      end
    end

    # tests next_page
    describe ".next_page" do
      it "sets page to invalid value above range" do
        @paginate.next_page.should eq(false)
        @paginate.current.should == 1
        @paginate.items_current.should == 0
        @paginate.next.should be_nil
        @paginate.prev.should be_nil
      end
    end

  end

  context "When using set values" do
    
    # setup for pagination set values testing
    before do
      # default values of current page set to the first page, 
      # 30 results per page, and 0 total items
      @paginate = Ohanakapa::Response::Pagination.new({:current_page=>2,\
        :per_page=>20,:count=>64})
    end

    describe ".current" do
      it "has current page of 1" do
        @paginate.current.should == 2
      end
    end

    describe ".next" do
      it "has a next page of 3" do
        @paginate.next.should == 3
      end
    end

    describe ".prev" do
      it "has a previous page of 1" do
        @paginate.prev.should == 1
      end
    end

    describe ".items_per_page" do
      it "has 20 results per page" do
        @paginate.items_per_page.should == 20
      end
    end

    describe ".pages_total" do
      it "has 4 page total" do
        @paginate.pages_total.should == 4
      end
    end

    describe ".items_total" do
      it "has 64 total items" do
        @paginate.items_total.should == 64
      end
    end

    describe ".items_current" do
      it "has 20 items on the current page" do
        @paginate.items_current.should == 20
      end
    end

    # tests goto_page
    describe ".goto_page(0)" do
      it "sets page to invalid value below range" do
        @paginate.goto_page(0).should eq(false)
        @paginate.current.should == 2
        @paginate.items_current.should == 20
        @paginate.next.should == 3
        @paginate.prev.should == 1
      end
    end

    describe ".goto_page(1)" do
      it "sets page to valid value" do
        @paginate.goto_page(1).should eq(true)
        @paginate.current.should == 1
        @paginate.items_current.should == 20
        @paginate.next.should == 2
        @paginate.prev.should be_nil
      end
    end

    describe ".goto_page(2)" do
      it "sets page to invalid value above range" do
        @paginate.goto_page(2).should eq(true)
        @paginate.current.should == 2
        @paginate.items_current.should == 20
        @paginate.next.should == 3
        @paginate.prev.should == 1
      end
    end

     describe ".goto_page(4)" do
      it "sets page to invalid value above range" do
        @paginate.goto_page(4).should eq(true)
        @paginate.current.should == 4
        @paginate.items_current.should == 4
        @paginate.next.should be_nil
        @paginate.prev.should == 3
      end
    end

    # tests prev_page
    describe ".prev_page" do
      it "sets page to invalid value below range" do
        @paginate.prev_page.should eq(true)
        @paginate.current.should == 1
        @paginate.items_current.should == 20
        @paginate.next.should == 2
        @paginate.prev.should be_nil

        @paginate.prev_page.should eq(false)
        @paginate.current.should == 1
        @paginate.items_current.should == 20
        @paginate.next.should == 2
        @paginate.prev.should be_nil
      end
    end

    # tests next_page
    describe ".next_page" do
      it "sets page to invalid value above range" do
        @paginate.next_page.should eq(true)
        @paginate.current.should == 3
        @paginate.items_current.should == 20
        @paginate.next.should == 4
        @paginate.prev.should == 2

        @paginate.next_page.should eq(true)
        @paginate.current.should == 4
        @paginate.items_current.should == 4
        @paginate.next.should be_nil
        @paginate.prev.should == 3

        @paginate.next_page.should eq(false)
        @paginate.current.should == 4
        @paginate.items_current.should == 4
        @paginate.next.should be_nil
        @paginate.prev.should == 3
      end
    end

  end

end
