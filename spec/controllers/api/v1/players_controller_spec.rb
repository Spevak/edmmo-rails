require 'spec_helper'

describe Api::V1::PlayersController do

  side_length = Tile.MAP_SIDE_LENGTH

  before(:each) do
    @user = FactoryGirl.create(:user)
    @tile = Tile.tile_at(0, 0)
    @character = @user.character
    @character.tile = @tile
    @character.save
    sign_in @user
  end

  Tile.destroy_all
  @tiles = (1..side_length ** 2).collect { FactoryGirl.create(:tile) }

  describe "POST #move" do

    context "valid move" do 
      it "moves the player and returns error code 0 (success)" do
        json = {direction: 'east'}
        post :move, json
        @character.tile.x.should eql 1
        @character.tile.y.should eql 0
        Tile.tile_at(0, 0).character.should eql nil
        JSON.parse(response.body)["err"].should eql 0
      end 
    end

    context "invalid move" do
      @tile = Tile.tile_at(0, 0)
      @tile.character = @character
      @tile.save

      it "does not move player and returns error code 1" do
        json = {direction: 'south'}
        post :move, json
        @character.tile.x.should eql 0
        @character.tile.y.should eql 0
        JSON.parse(response.body)["err"].should eql 1
      end 
    end 

  end

  describe "POST #pickup" do

    context "valid pickup" do
      @item = FactoryGirl.create(:item)
      @tile = Tile.tile_at(0, 0)
      @tile.character = @character
      @tile.item = @item
      @tile.save
      it "picks up an item and put it in the player's hands. Return error code 0" do
        json = {x: 0, y: 0, itemID: @item.id}
        post :pickup, json
        @character.item.id.should eql @item.id
        @tile.item.should eql nil
        JSON.parse(response.body)["err"].should eql 0
      end
    end

    context "item not there" do
      @item = FactoryGirl.create(:item)
      @tile = Tile.tile_at(0, 0)
      @tile.character = @character
      @tile.save
      it "returns error code 1" do
        json = {x: 0, y: 0, itemID: @item.id}
        post :pickup, json
        @character.item.should eql nil
        JSON.parse(response.body)["err"].should eql 1
      end
    end

    context "tile not accessible" do
      it "returns error code 2" do
        @item = FactoryGirl.create(:item)
        tile2 = Tile.tile_at(1, 0)
        tile2.item = @item
        tile2.save
        json = {x: 1, y: 0, itemID: @item.id}
        post :pickup, json
        @character.item.should eql nil
        JSON.parse(response.body)["err"].should eql 2
      end
    end

    context "hands occupied" do
      it "returns error code 3" do
        @item = FactoryGirl.create(:item)
        @tile.item = @item
        @tile.save
        @item2 = FactoryGirl.create(:item)
        @character.item = @item2
        @character.save
        json = {x: 0, y: 0, itemID: @item.id}
        post :pickup, json
        @character.item.id.should eql @item2.id
        @tile.item.id.should eql @item.id
        JSON.parse(response.body)["err"].should eql 3
      end
    end

  end

  describe "POST #drop" do

    context "valid drop" do
      it "drops an item and returns error code 0" do
        @item = FactoryGirl.create(:item)
        @character.item = @item
        @character.save
        json = {x: 0, y: 0, itemID: @item.id}
        post :drop, json
        @tile.item.id.should eql  @item.id
        @character.item.should eql nil
        JSON.parse(response.body)["err"].should eql 0
      end
    end
    
    context "does not have such item" do
      it "returns error code 1" do
      end
    end

    context "tile occupied by another item" do
      it "returns error code 2" do
        @item = FactoryGirl.create(:item)
        @tile.item = @item
        @tile.save
        @item2 = FactoryGirl.create(:item)
        @character.item = @item2
        @character.save
        json = {x: 0, y: 0, itemID: @item2.id}
        post :drop, json
        @tile.item.id.should eql @item.id
        @character.item.id.should eql @item2.id
        JSON.parse(response.body)["err"].should eql 1
      end
    end

  end

  describe "POST #use" do
    it "uses an item"
  end

  describe "GET #status" do
    it "reports player status" do
    end
  end

  describe "GET #inspect" do
    it "inspects an item"
  end

  describe "GET #characters" do
    it "returns all characters"
  end
  Tile.destroy_all
end
