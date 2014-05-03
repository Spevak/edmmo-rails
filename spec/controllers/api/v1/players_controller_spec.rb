require 'spec_helper'

describe Api::V1::PlayersController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @character = @user.character
    @tile = Tile.first
    @character.tile = @tile
    @character.save!
  end

  describe "POST #move" do

    context "valid move" do 
      it "moves the player and returns error code 0 (success)" do
        @character.tile = Tile.tile_at(0, 0)
        @character.save!
        json = {direction: 'east'}
        post :move, json
        @character.reload
        @character.tile.x.should eql 1
        @character.tile.y.should eql 0
        Tile.tile_at(1, 0).characters.should include @character
        Tile.tile_at(0, 0).characters.length.should eq 0
        JSON.parse(response.body)["err"].should eql 0
      end 
    end
    
    context "valid move west" do
        it "moves the player and returns error code 0 (success)" do
            @character.tile = Tile.tile_at(1, 0)
            @character.save!
            json = {direction: 'west'}
            post :move, json
            @character.reload
            @character.tile.x.should eql 0
            @character.tile.y.should eql 0
            Tile.tile_at(0, 0).characters.should include @character
            Tile.tile_at(1, 0).characters.length.should eq 0
            JSON.parse(response.body)["err"].should eql 0
        end 
    end

    context "invalid move" do
      it "does not move player and returns error code 1" do
        @character.tile = Tile.tile_at(0, 0)
        @character.save!
        json = {direction: 'south'}
        post :move, json
        @character.reload
        @character.tile.x.should eql 0
        @character.tile.y.should eql 0
        JSON.parse(response.body)["err"].should eql 1
      end 
    end
    
    context "invalid direction" do
        it "does not move player and returns error code 1" do
            @character.tile = Tile.tile_at(0, 0)
            @character.save!
            json = {direction: 'not_a_dir'}
            post :move, json
            @character.reload
            @character.tile.x.should eql 0
            @character.tile.y.should eql 0
            JSON.parse(response.body)["err"].should eql 1
        end 
    end
    
    context "walk into a boulder" do
        it "does not move player and returns error code 1" do
            @character.tile = Tile.tile_at(0, 0)
            north_tile = Tile.tile_at(@character.tile.x, @character.tile.y + 1)
            north_tile.tile_type = 4
            north_tile.save
            @character.save!
            json = {direction: 'north'}
            post :move, json
            @character.reload
            @character.tile.x.should eql 0
            @character.tile.y.should eql 0
            JSON.parse(response.body)["err"].should eql 1
        end
    end
    
    context "walk with no battery" do
        it "does not move player and returns error code 1" do
            @character.tile = Tile.tile_at(0, 0)
            @character.battery = 0
            @character.save!
            json = {direction: 'north'}
            post :move, json
            @character.reload
            @character.tile.x.should eql 0
            @character.tile.y.should eql 0
            JSON.parse(response.body)["err"].should eql 2
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
    context "use a potato to recharge" do
        it "should increase character's battery" do
            
            @tile.item = nil
            @tile.save!
            @character.item = nil
            @character.save
            
            post :dig
            
            @character.reload
            @tile.reload
            
            origBat = @character.battery
            myid = @character.item.id
            json = {item_id: myid, args: nil}
            post :use, json
            
            @character.reload
            #@character.should_receive(:use_item)
            JSON.parse(response.body)["err"].should eql 0
            @character.battery.should eql (origBat + 10)
        end
    end
  end

  describe "GET #status" do
    it "reports player status, health, battery" do
      post :status
      JSON.parse(response.body)["health"].should eql 100
      JSON.parse(response.body)["battery"].should eql 100
    end
    
    it "returns 404 if user signed out" do
        sign_out @user
        post :status
        response.status.should eq 404
    end
  end

  describe "POST #inspect" do
    
    context "sign tile" do
      it "returns a string that starts with a 'sign that says'" do
        north_tile = Tile.tile_at(@tile.x, @tile.y + 2)
        north_tile.tile_type = 16
        north_tile.save
        @character.move_direction('north')
        post :inspect, json: { :args => "" }
        JSON.parse(response.body)["msg"].should start_with "Sign:"
      end
    end

    context "invalid tile" do
    end

  end

  describe "POST #face" do
      
      context "face north" do
          it "updates the character database to 0" do
              @character.face('north')
              @character.facing.should eql 0
              end
          end
      
      context "face east" do
          it "updates the character database to 0" do
              @character.face('east')
              @character.facing.should eql 1
            end
        end
      
      context "face south" do
          it "updates the character database to 0" do
              @character.face('south')
              @character.facing.should eql 2
            end
        end
      
      context "face west" do
          it "updates the character database to 0" do
              @character.face('west')
              @character.facing.should eql 3
            end
        end
      
      context "face invalid" do
          it "does not update the character db" do
              @character.face('north')
              @character.face('not_a_dir')
              @character.facing.should eql 0
            end
        end
      
      end

  describe "POST #dig" do
      it "digs up a potato" do
          @tile.item = nil
          @tile.save!
          @character.item = nil
          @character.save
          
          post :dig
          
          @character.reload
          @tile.reload
          
          myid = @character.item.id
          
          JSON.parse(response.body)["err"].should eql 0
          @character.item.id.should eql myid
          @character.item.id.should_not eql nil
          end
      end

  describe "GET #characters" do
    it "returns all characters in json objects" do
      get :characters
        JSON.parse(response.body).length.should eql Character.count
      end
    end
  end
