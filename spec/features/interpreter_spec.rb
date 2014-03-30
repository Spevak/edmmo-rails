require 'spec_helper'

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

describe "The splash page" do
  it "loads" do
    #Run this test in development environment using the stub_env helper method defined in spec_helper
    #this allows us to bypass the login page
    stub_env "development" do
      #navigate to welcome page
      visit('')
<<<<<<< HEAD
      expect(page).to have_css('div#dashboard')
=======
      expect(page).to have_content 'Welcome to Bot Quest!'
>>>>>>> ui
    end
  end
end

#sort of a smoke test to make sure skulpt is working on our page
describe "Skulpt" do
  it "works (runs a print statement)", :js => true do
    #run in development env to bypass login
    stub_env "development" do
      #load splash page
      visit('')
      #note: inner quotes in python line below MUST be single quotes, as the line will be inserted directly
      #into a javascript string delimited by double quotes
      result = runPython("print('Hello World')")
      expect(result).to eq("Hello World")
    end
  end
end


describe "The builtin go function" do
  it "runs and returns a 0 err code", :js => true do
    #run in dev env to bypass login
    stub_env "development" do
      #load home page
      visit('')
      #Have to print result to see it because skulpt doesn't use the output function for return values
      result = runPython("print(go('north'))")
      expect(result).to eq("0")
    end
  end
end

# NOTE: All quotes in Python script MUST be in single quotes
# TODO: Test the other functions

describe "The builtin go function - illegal move" do
    it "runs and returns a 1 err code", :js => true do
        #run in dev env to bypass login
        stub_env "development" do
            #load home page
            visit('')
            #Have to print result to see it because skulpt doesn't use the output function for return values
            # Before this line, set the gamestate's map to be something such that go('west') runs into a boulder/wall
            result = runPython("print(go('west'))")
            puts "result: " + result
            expect(result).to eq("1")
        end
    end
end

describe "The builtin go function - no battery" do
    it "runs and returns a 2 err code", :js => true do
        #run in dev env to bypass login
        stub_env "development" do
            #load home page
            visit('')
            #Have to print result to see it because skulpt doesn't use the output function for return values
            num = 0
            # Assumes battery value of 50, change to whatever value is
            while num < 50
                runPython("go('north')")
                num = num + 1
            end
            result = runPython("print(go('south'))")
            puts "result: " + result
            expect(result).to eq("2")
        end
    end
end

describe "The builtin pickup function" do
    it "runs and returns a 0 err code", :js => true do
        #run in dev env to bypass login
        stub_env "development" do
            #load home page
            visit('')
            #Have to print result to see it because skulpt doesn't use the output function for return values
            #Before this, initialize a potato at starting position
            result = runPython("print(pickup(0,0,'potato'))")
            puts "result: " + result
            expect(result).to eq("0")
        end
    end
end

describe "The builtin pickup function - no item" do
    it "runs and returns a 1 err code", :js => true do
        #run in dev env to bypass login
        stub_env "development" do
            #load home page
            visit('')
            #Have to print result to see it because skulpt doesn't use the output function for return values
            result = runPython("print(pickup(0,0,'potato'))")
            puts "result: " + result
            expect(result).to eq("1")
        end
    end
end

describe "The builtin pickup function - not accessible" do
    it "runs and returns a 2 err code", :js => true do
        #run in dev env to bypass login
        stub_env "development" do
            #load home page
            visit('')
            #Have to print result to see it because skulpt doesn't use the output function for return values
            #Initialize a potato at 10,10 just to be a dick
            result = runPython("print(pickup(10,10,'potato'))")
            puts "result: " + result
            expect(result).to eq("2")
        end
    end
end

describe "The builtin pickup function - full hands" do
    it "runs and returns a 3 err code", :js => true do
        #run in dev env to bypass login
        stub_env "development" do
            #load home page
            visit('')
            #Have to print result to see it because skulpt doesn't use the output function for return values
            # Initialize potatos at 0,0 and 0,1
            runPython("pickup(0,0,'potato')")
            runPython("(go('north')")
            result =runPython("print(pickup(0,1,'potato'))")
            puts "result: " + result
            expect(result).to eq("3")
        end
    end
end

describe "The builtin drop function" do
    it "runs and returns a 0 err code", :js => true do
#run in dev env to bypass login
        stub_env "development" do
#load home page
            visit('')
#Have to print result to see it because skulpt doesn't use the output function for return values
#Before this, initialize a potato at starting position and 0,1
            runPython("pickup(0,0,'potato')")
            result = runPython("print(drop('potato'))")
            puts "result: " + result
            expect(result).to eq("0")
        end
    end
end

describe "The builtin drop function - no item" do
    it "runs and returns a 1 err code", :js => true do
#run in dev env to bypass login
        stub_env "development" do
#load home page
            visit('')
#Have to print result to see it because skulpt doesn't use the output function for return values
#Before this, initialize a potato at starting position and 0,1
            runPython("pickup(0,0,'potato')")
            result = runPython("print(drop('rock'))")
            puts "result: " + result
            expect(result).to eq("1")
        end
    end
end

describe "The builtin drop function - no space" do
    it "runs and returns a 2 err code", :js => true do
#run in dev env to bypass login
        stub_env "development" do
#load home page
            visit('')
#Have to print result to see it because skulpt doesn't use the output function for return values
#Before this, initialize a potato at starting position and 0,1
            runPython("pickup(0,0,'potato')")
            runPython("go('north')")
            result = runPython("print(drop('potato'))")
            puts "result: " + result
            expect(result).to eq("2")
        end
    end
end

describe "The builtin dig function" do
    it "runs and eventually returns 0 err code", :js => true do
#run in dev env to bypass login
        stub_env "development" do
#load home page
            visit('')
#Have to print result to see it because skulpt doesn't use the output function for return values
#Before this, initialize a potato at starting position and 0,1
            result = -1
            while result != 0
               if result != 0
                    result = runPython("(dig()")
                else
                    result = runPython("print(dig())")
                end
            end
            puts "result: " + result
            expect(result).to eq("0")
        end
    end
end

describe "The builtin use function" do
    it "runs and returns a 0 err code", :js => true do
        #run in dev env to bypass login
        stub_env "development" do
            #load home page
            visit('')
            #Have to print result to see it because skulpt doesn't use the output function for return values
            #Before this, initialize a potato at starting position
            runPython("pickup(0,0,'potato')")
            result = runPython("print(use('potato', 'battery'))")
            puts "result: " + result
            expect(result).to eq("0")
        end
    end
end

describe "The builtin use function - no item" do
    it "runs and returns a 1 err code", :js => true do
        #run in dev env to bypass login
        stub_env "development" do
            #load home page
            visit('')
            #Have to print result to see it because skulpt doesn't use the output function for return values
            #Before this, initialize a potato at starting position
            result = runPython("print(use('potato', 'battery'))")
            puts "result: " + result
            expect(result).to eq("1")
        end
    end
end

describe "The builtin use function - bad args" do
    it "runs and returns a 2 err code", :js => true do
        #run in dev env to bypass login
        stub_env "development" do
            #load home page
            visit('')
            #Have to print result to see it because skulpt doesn't use the output function for return values
            #Before this, initialize a potato at starting position
            runPython("pickup(0,0,'potato')")
            result = runPython("print(use('potato', 'love'))")
            puts "result: " + result
            expect(result).to eq("2")
        end
    end
end

describe "The builtin inspect function" do
    it "runs and returns a 0 err code", :js => true do
        #run in dev env to bypass login
        stub_env "development" do
            #load home page
            visit('')
            #Have to print result to see it because skulpt doesn't use the output function for return values
            #Before this, initialize a potato at starting position
            runPython("pickup(0,0,'potato')")
            result = runPython("print(inspect('potato'))")
            puts "result: " + result
            expect(result).to eq("0")
        end
    end
end

describe "The builtin inspect function - no item" do
    it "runs and retuns a 1 err code", :js => true do
        #run in dev env to bypass login
        stub_env "development" do
            #load home page
            visit('')
            #Have to print result to see it because skulpt doesn't use the output function for return values
            #Before this, initialize a potato at starting position
            result = runPython("print(inspect('potato'))")
            puts "result: " + result
            expect(result).to eq("1")
        end
    end
end

describe "The builtin tiles function" do
    it "runs and retuns a 0 err code", :js => true do
        #run in dev env to bypass login
        stub_env "development" do
            #load home page
            visit('')
            #Have to print result to see it because skulpt doesn't use the output function for return values
            #Before this, initialize a potato at starting position
            result = runPython("print(tiles())")
            puts "result: " + result
            expect(result).to eq("0")
        end
    end
end
