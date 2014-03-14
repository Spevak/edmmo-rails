class WelcomeController < ApplicationController
  def index
    unless user_signed_in? or Rails.env.development? then
      redirect_to new_user_session_path
    end
  end
end
