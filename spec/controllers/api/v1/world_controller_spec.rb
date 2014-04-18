require 'spec_helper'

describe Api::V1::WorldController do

  describe '.tiles' do
    context 'while signed in' do
      it 'calls .tiles_at' do
        user = FactoryGirl.create(:user)
        character = FactoryGirl.create(:character)
        tile = Tile.first
        tile.character = character
        tile.save!
        sign_in user

        Tile.should_receive(:tiles_at)
        post :tiles
        response.status.should eq 200
        response.body.keys.should include("tiles")
        response.body.keys.should include("player_x")
        response.body.keys.should include("player_y")
        response.body.keys.should include("other_players")
        response.body.keys.should include("world_items")
      end
    end

    context 'while not signed in' do
      it 'renders {} with forbidden status' do
        post :tiles
        response.status.should eq 403
      end
    end
  end

end
