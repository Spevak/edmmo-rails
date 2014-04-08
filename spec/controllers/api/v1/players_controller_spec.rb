require 'spec_helper'

describe Api::V1::PlayersController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @character = @user.character
    @tile = Tile.first
    @tile.character = @character
    @tile.save!
  end

  describe "POST #move" do

    context "valid move" do 
      it "moves the player and returns error code 0 (success)" do
        @character.setTile(Tile.tile_at(0, 0))
        @character.save!
        json = {direction: 'east'}
        post :move, json
        @character.reload
        @character.tile.x.should eql 1
        @character.tile.y.should eql 0
        Tile.tile_at(1, 0).character.should eql @character
        Tile.tile_at(0, 0).character.should eql nil
        JSON.parse(response.body)["err"].should eql 0
      end 
    end

    context "invalid move" do
      it "does not move player and returns error code 1" do
        @character.setTile(Tile.tile_at(0, 0))
        @character.save!
        json = {direction: 'south'}
        post :move, json
        @character.reload
        @character.tile.x.should eql 0
        @character.tile.y.should eql 0
        JSON.parse(response.body)["err"].should eql 1
      end 
    end 

  end

  describe "POST #pickup" do

    context "valid pickup" do
      it "picks up an item and put it in the player's hands. Return error code 0" do
        @item = FactoryGirl.create(:item)
        @tile.item = @item
        @tile.save!
        json = {
          :x => @character.x,
          :y => @character.y,
          :item_id => @item.id
        }
        post :pickup, json
        @character.reload
        @tile.reload
        JSON.parse(response.body)["err"].should eql 0
        @character.item.id.should eql @item.id
        @tile.item.should eql nil
      end
    end

    context "item not there" do
      it "returns error code 1" do
        @item = FactoryGirl.create(:item)
        json = {x: 0, y: 0, item_id: @item.id}
        post :pickup, json
        @character.item.should eql nil
        JSON.parse(response.body)["err"].should eql 1
      end
    end

    context "item does not exist in this world" do
      it "returns error code 1" do
        json = {x: 0, y: 0, item_id: 12345}
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
        json = {x: 1, y: 0, item_id: @item.id}
        post :pickup, json
        @character.tile.x.should eql 0
        @character.tile.y.should eql 0
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
        json = {x: 0, y: 0, item_id: @item.id}
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

        @tile.item = nil
        @tile.save!

        @item = FactoryGirl.create(:item)
        @character.item = @item
        @character.save!

        json = {:item_id => @item.id}
        post :drop, json

        @character.reload
        JSON.parse(response.body)["err"].should eql 0
        @character.item.should eql nil
        @character.tile.item.id.should eql @item.id
      end
    end
    
    context "does not have such item" do
      it "returns error code 1" do
          old_tile_id = @tile.item.id
          @item = FactoryGirl.create(:item)
          @character.item = @item
          @character.save
          
          json = {:item_id => @item.id + 1}
          post :drop, json
          
          @tile.item.id.should eql old_tile_id
          @character.item.id.should eql @item.id
          JSON.parse(response.body)["err"].should eql 1
      end
    end

    context "tile occupied by another item" do
      it "returns error code 2" do
        @item = FactoryGirl.create(:item)
        @tile.item = @item
        @tile.save!

        @item2 = FactoryGirl.create(:item)
        @character.item = @item2
        @character.save!

        json = {x: 0, y: 0, item_id: @item2.id}
        post :drop, json
        @tile.item.id.should eql @item.id
        @character.item.id.should eql @item2.id
        
        JSON.parse(response.body)["err"].should eql 2
      end
    end
  end

  describe "POST #use" do
    #TODO test to be improved when use_item is fully functional
    context "valid use" do
      it "uses an item and returns error code 0" do
        @item = FactoryGirl.create(:item)
        @character.item = @item
        @character.save
        json = {item_id: @item.id, args: nil}
        post :use, json
        #@character.should_receive(:use_item)
        JSON.parse(response.body)["err"].should eql 0
      end
    end
    context "does not have item" do
      it "returns error code 1" do
        @item = FactoryGirl.create(:item)
        @item2 = FactoryGirl.create(:item)
        @character.item = @item
        @character.save
        json = {item_id: @item2.id, args: nil}
        post :use, json
        #@character.should_not_receive(:use_item)
        JSON.parse(response.body)["err"].should eql 1
      end
    end
    context "bad arguments" do
      it "returns error code 2" do
        #TODO
      end
    end
  end

  describe "GET #status" do
    it "reports player status, hp, battery" do
      post :status
      JSON.parse(response.body)["hp"].should eql 100
      JSON.parse(response.body)["battery"].should eql 100
    end
  end

  describe "POST #inspect" do
    context "valid item" do
      it "inspects an item" do
        @item = FactoryGirl.create(:item)
        @character.item = @item
        @character.save!
        json = {
          item_id: @item.id
        }
        post :inspect, json
        JSON.parse(response.body)["err"].should eql 0
        JSON.parse(response.body)["item"].should eql JSON.parse(@item.to_json)
      end
    end
    context "does not have that item" do
      it "returns error code 1" do
        #TODO implement after inventory is done
      end
    end
  end

  describe "GET #characters" do
    it "returns all characters in json objects" do
      get :characters
        JSON.parse(response.body).length.should eql Character.count
      end
    end
  end
