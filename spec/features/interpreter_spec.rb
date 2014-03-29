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
      expect(page).to have_content 'Welcome to Bot Quest!'
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
  it "runs and retuns a 0 err code", :js => true do
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

    
