require 'spec_helper'

describe "The splash page" do
  it "loads" do
    #Run this test in development environment
    stub_env "development" do
      #navigate to welcome page
      visit('')
      expect(page).to have_content 'Welcome to bot quest!'
    end
  end
end

describe "The builtin go function" do
  it "recieves a response from the server", :js => true do
    stub_env "development" do
      visit('')
      #find the text entry box for the interpreter
      text_box = find('#interactive', :visible => false)     
      #text_box.set("go('north')")
      fill_in '#interactive', :visible => false, :with => "go('north')"
      #text_box.trigger(:mouseover)
      puts(text_box.text)
    end
  end
end
    
