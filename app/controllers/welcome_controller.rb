class WelcomeController < ApplicationController
  def index
    unless user_signed_in? or Rails.env.development? then
      redirect_to new_user_session_path
    end
    puts "/////////////////////////////////"
    puts current_user.id
    puts "/////////////////////////////////"
    if current_user.character == nil then
      character = Character.create(name: "robot9000", health: 100, battery: 100, facing: 0, planet: 1)
      character.setTile(Tile.first)
      character.save!
      current_user.character = character
      current_user.save!
    end
  end
end
