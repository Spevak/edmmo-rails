desc "Builds the interpreter from skulpt source and puts the resulting javascript files into app/assets/javascritps/interpreter"
task :build_skulpt do
     system('(cd skulpt; python m dist)')
     system('(cp skulpt/dist/skulpt.min.js app/assets/javascripts/interpreter/skulpt.min.js)')
     system('(cp skulpt/dist/skulpt-stdlib.js app/assets/javascripts/interpreter/skulpt-stdlib.js)')

end
