class WelcomeController < ApplicationController
  def index
    unless user_signed_in? or Rails.env.development? then
      redirect_to new_user_session_path
    end

    if current_user.character == nil then
      character = Character.create(name: "robot9000", health: 100, battery: 100, facing: 0, planet: 1)
      character.setTile(Tile.tile_at(10, 10))
      character.save!
      current_user.character = character
      current_user.save!
    elsif current_user.character.tile == nil then
      #Change this so we spawn in a meaningful location 
      current_user.character.setTile(Tile.tile_at(0,0))
    end
  end
end
