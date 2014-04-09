require 'spec_helper'

describe MapController do

  describe "GET 'editor'" do
    it "returns http success" do
      get 'editor'
      response.should be_success
    end
  end

end
