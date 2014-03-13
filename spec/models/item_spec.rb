require 'spec_helper'

describe Item do
  it "should be valid" do
    FactoryGirl.build(:item).should be_valid
  end
end
