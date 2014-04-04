class WelcomeController < ApplicationController
  def index
    unless user_signed_in? or Rails.env.development? then
      redirect_to new_user_session_path
    end
    if current_user.character == nil then
      current_user.character = Character.create(name: "robot9000", health: 100, battery: 100, facing: "north", planet: "bot's planet") 
      current_user.character.tile = Tile.first
    end
  end
end
