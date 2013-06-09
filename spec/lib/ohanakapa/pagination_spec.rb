require 'spec_helper'
require 'ohanakapa/pagination'

describe Ohanakapa::Pagination do

  before do
    @paginate = Ohanakapa::Pagination.new(1,30,64)
  end

  describe "checks initial values" do
      it{@paginate.current.should == 1}
      it{@paginate.next.should == 2}
      it{@paginate.prev.should be_nil}
      it{@paginate.items_per_page.should == 30}
      it{@paginate.items_total.should == 64}
      it{@paginate.pages_total.should == 3}
      it{@paginate.items_current.should == 30}
  end
  
  describe ".goto_page" do

    it "goes to a page" do
      @paginate.goto_page(0).should eq(false)

      @paginate.goto_page(1).should eq(true)
      @paginate.current.should == 1
      @paginate.next.should == 2
      @paginate.prev.should be_nil


      @paginate.goto_page(2).should eq(true)
      @paginate.current.should == 2
      @paginate.next.should == 3
      @paginate.prev.should == 1
      @paginate.items_current.should == 30


      @paginate.goto_page(3).should eq(true)
      @paginate.current.should == 3
      @paginate.next.should be_nil
      @paginate.prev.should == 2
      @paginate.items_current.should == 4

      @paginate.goto_page(4).should eq(false)
      @paginate.current.should == 3
      @paginate.next.should be_nil
      @paginate.prev.should == 2
      @paginate.items_current.should == 4
    end

  end

  describe ".next_page" do

    it "advances a page" do
      @paginate.next_page.should eq(true)
      @paginate.current.should == 2
      @paginate.next.should == 3
      @paginate.prev.should == 1
      @paginate.items_current.should == 30


      @paginate.next_page.should eq(true)
      @paginate.current.should == 3
      @paginate.next.should be_nil
      @paginate.prev.should == 2
      @paginate.items_current.should == 4

      @paginate.next_page.should eq(false)
      @paginate.current.should == 3
      @paginate.next.should be_nil
      @paginate.prev.should == 2
      @paginate.items_current.should == 4
    end

  end

  describe ".prev_page" do

    it "retracts a page" do
      @paginate.prev_page.should eq(false)
      @paginate.current.should == 1
      @paginate.next.should == 2
      @paginate.prev.should be_nil
      @paginate.items_current.should == 30

      @paginate.goto_page(3).should eq(true)
      @paginate.current.should == 3
      @paginate.next.should be_nil
      @paginate.prev.should == 2
      @paginate.items_current.should == 4

      @paginate.prev_page.should eq(true)
      @paginate.current.should == 2
      @paginate.next.should == 3
      @paginate.prev.should == 1
      @paginate.items_current.should == 30

      @paginate.prev_page.should eq(true)
      @paginate.current.should == 1
      @paginate.next.should == 2
      @paginate.prev.should be_nil
      @paginate.items_current.should == 30

      @paginate.prev_page.should eq(false)
      @paginate.current.should == 1
      @paginate.next.should == 2
      @paginate.prev.should be_nil
      @paginate.items_current.should == 30
    end

  end

end
