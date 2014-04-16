require 'spec_helper'

describe Item do
  it "should be valid" do
    FactoryGirl.build(:item).should be_valid
  end

  context "factory" do
    it "should create a valid item" do
    end

    it "should create the right type of item" do
    end
  end

  describe ".do_action" do
    it "should call the action function" do
    end
  end
end
