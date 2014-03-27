require 'spec_helper'

describe User do
  describe ".logged_in_users" do
    it "returns all logged in users" do
      @users = (1..5).collect { FactoryGirl.create(:user) }
      @users.each do |u|
        sign_in u
      end
      logged_in_users = User.logged_in_users
      logged_in_users.count.should eq(5)
    end
  end
end
