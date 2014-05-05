class WelcomeController < ApplicationController
  def index
    if Rails.env.production? or Rails.env.development? then 
      if not user_signed_in? then
        redirect_to new_user_session_path
      else
        if current_user.character == nil then
          character = Character.create(name: "robot9000", health: 100, battery: 100, facing: 0, planet: 1)
          character.tile = Tile.tile_at(11, 10)
          character.save!
          current_user.character = character
          current_user.save!
        elsif current_user.character.tile == nil then
          #Change this so we spawn in a meaningful location 
          current_user.character.tile = Tile.tile_at(11,10)
        end
      end
    end
  end
end
