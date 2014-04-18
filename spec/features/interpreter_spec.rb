require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

#Some configuration values which we should sparate from the test logic so
#we can change the frontend spec without changing the test code
MAP_MAX_INDEX = 12
GO_RESPONSES = {:legal => "0", :illegal => "1", :immobilized => '2'}
PICKUP_RESPONSES = {:success => "0", :no_item => "1", :no_access => '2', :no_space => '3'}
DROP_RESPONSES = {:success => "0", :no_item => "1", :occupied => "2"}
DIG_RESPONSES = {:success => "0", :failure => "1"}
USE_RESPONSES = {:success => "0", :no_item => "1", :bad_args => "2"}
INSPECT_RESPONSES = {:success => "0", :no_item => "1"}
STATUS_RESPONSES = {:success => "{'hp': 100, 'battery': 100}"}
TILES = {:center => '0', :nw => '1', :ne => '2', :sw => '3', :se => '4'}

#Helper for executing python code and getting the result
#Javascript calls are separated to facilitate debugging
def runPython(code)
  #define a function to print to the pre block with id 'output' and set it as 
  #skulpt's output function, so we can easily access skulpt's output
  page.execute_script('function outf(text) {document.getElementById("output").innerHTML += text}')
  page.execute_script('Sk.output = outf')

  #eval the python code
  eval_call = 'ret = eval(Sk.importMainWithBody("<stdin>", false, "'
  eval_call = eval_call + code + '"))'
  page.execute_script(eval_call)

  #grab the result and return it 
  out = find('#output', :visible=>false)
  return out.text
end

#helper to get id of tile at position (x,y) on map
def getTile(x,y) 
  call = 'document.getElementById("output").innerHTML = Bq.mapData.tileAt(' +x.to_s+','+y.to_s+');'
  page.execute_script(call)
  return find('#output', :visible=>false).text
end
 
################################################################
# TESTS ARE BELOW
#
# -In all tests, use the stub_env helper defined in spec_helper to
#  specify environment (use development to bypass login page)
#
# -If python code contains a string, it must be in single quotes
#  because runPython will concat it with a double-quoted string
# -These tests are designed to be run in the test backend, which is
#  designed to send each possible response given the right argument.
#  This is so we can separate the front and back end for unit testing
#  Therefore these tests should not pass on the production back end.
################################################################
describe "Interpreter" do
  before(:all) do
    user = FactoryGirl.create(:user)
    character = FactoryGirl.create(:character)
    character.setTile(Tile.tile_at(0, 0))
    character.save!
    user.character = character
    user.save!
  end

  describe "The splash page" do
    it "loads the dashboard" do
      stub_env "development" do
        visit('')
        expect(page).to have_css('div#dashboard')
      end
    end
  end

  #sort of a smoke test to make sure skulpt is working on our page
  describe "Skulpt" do
    it "works (runs a print statement)", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print('Hello World')")
        expect(result).to eq("Hello World")
      end
    end
  end

  describe "The builtin go function" do
    it "retuns " + GO_RESPONSES[:legal] + " on legal move", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(go('north'))")
        expect(result).to eq(GO_RESPONSES[:legal])
      end
    end

    it "returns " + GO_RESPONSES[:illegal] + " on illegal move" , :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(go('west'))")
        expect(result).to eq(GO_RESPONSES[:illegal])
      end
    end

    it "returns " + GO_RESPONSES[:immobilized] + " when immobilized", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(go('south'))")
        expect(result).to eq(GO_RESPONSES[:immobilized])
      end
    end
  end

  describe "The builtin pickup function" do
    it "returns " + PICKUP_RESPONSES[:success] + " on success", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(pickup(0,0,'potato'))")
        expect(result).to eq(PICKUP_RESPONSES[:success])
      end
    end

    it "returns " + PICKUP_RESPONSES[:no_item] + " when item does not exist", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(pickup(0,0,'cake'))")
        expect(result).to eq(PICKUP_RESPONSES[:no_item])
      end
    end

    it "returns " + PICKUP_RESPONSES[:no_access] + " when item is not accessible", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(pickup(10,0,'potato'))")
              expect(result).to eq(PICKUP_RESPONSES[:no_access])
      end
    end

    it "returns " + PICKUP_RESPONSES[:no_space] + "when hands are full.", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(pickup(0,1,'potato'))")
        expect(result).to eq(PICKUP_RESPONSES[:no_space])
      end
    end
  end

  describe "The builtin drop function" do
    it "returns " + DROP_RESPONSES[:success] + " on success", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(drop('potato'))")
        expect(result).to eq(DROP_RESPONSES[:success])
      end
    end

    it "returns " + DROP_RESPONSES[:no_item] + " when the item doesn't exist", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(drop('nothing'))")
        expect(result).to eq(DROP_RESPONSES[:no_item])
      end
    end  

    it "returns " + DROP_RESPONSES[:occupied] + " when the tile is occupied.", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(drop('occupied'))")
        expect(result).to eq(DROP_RESPONSES[:occupied])
      end
    end
  end

  #This one is hard because we can't send an argument to tell the test backend which response to give
  #for now just have the backend return 0
  describe "The builtin dig function" do
      it "returns " + DIG_RESPONSES[:success] + " on success", :js => true do
      stub_env "development" do
        visit('')
        #result = -1
        #while result != 0
        #  if result != 0
        #    result = runPython("(dig()")
        #  else
        #    result = runPython("print(dig())")
        #  end
        #end
        result = runPython("print(dig())")
        expect(result).to eq(DIG_RESPONSES[:success])
      end
    end
  end

  describe "The builtin use function" do
    it "returns " + USE_RESPONSES[:success] + " on success", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(useItem('potato', 'battery'))")
        expect(result).to eq(USE_RESPONSES[:success])
      end
    end

    it "returns " + USE_RESPONSES[:no_item] + " when the item does not exist", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(useItem('cake', 'battery'))")
        expect(result).to eq(USE_RESPONSES[:no_item])
      end
    end

    it "returns " + USE_RESPONSES[:bad_args] + " when passed a bad argument string", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(useItem('potato', 'bad'))")
        expect(result).to eq(USE_RESPONSES[:bad_args])
      end
    end
  end

  describe "The builtin inspect function" do
    it "returns " + INSPECT_RESPONSES[:success] +  " on success", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(inspect('potato'))")
        expect(result).to eq(INSPECT_RESPONSES[:success])
      end
    end
    it "returns " + INSPECT_RESPONSES[:no_item] + " when item does not exist", :js => true do
      stub_env "development" do
        visit('')
        result = runPython("print(inspect('cake'))")
              expect(result).to eq(INSPECT_RESPONSES[:no_item])
          end
      end
  end

  #describe 'the builtin status function' do
  #  it 'retuns a dict of hp and battery' do
  #    stub_env "development" do
  #      visit('')
  #      result = runPython("print(status())")
  #      expect(result).to eq(STATUS_RESPONSES[:success])
  #    end
  #  end
  #end


  describe "The builtin tiles function" do
    it "loads the correct tile in the center", :js => true do
      stub_env "development" do
        visit('')
        runPython('tiles()')
        result = getTile(0,0)
        expect(result).to eq(TILES[:center])
      end
    end
  end

    it "loads the correct tile in the northwest corner", :js => true do
      stub_env "development" do
        visit('')
        runPython('tiles()')
        result = getTile(-MAP_MAX_INDEX, MAP_MAX_INDEX)
        expect(result).to eq(TILES[:nw])
      end
    end

    it "loads the correct tile in the northeast corner", :js => true do
      stub_env "development" do
        visit('')
        runPython('tiles()')
        result = getTile(MAP_MAX_INDEX, MAP_MAX_INDEX)
        expect(result).to eq(TILES[:ne])
      end
    end

    it "loads the correct tile in the southwest corner", :js => true do
      stub_env "development" do
        visit('')
        runPython('tiles()')
        result = getTile(-MAP_MAX_INDEX, -MAP_MAX_INDEX)
        expect(result).to eq(TILES[:sw])
      end
    end

    it "loads the correct tile in the southeast corner", :js => true do
      stub_env "development" do
        visit('')
        runPython('tiles()')
        result = getTile(MAP_MAX_INDEX, -MAP_MAX_INDEX)
        expect(result).to eq(TILES[:se])
      end
    end
end
