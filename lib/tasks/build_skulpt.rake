desc "Builds the interpreter from skulpt source and puts the resulting javascript files into app/assets/javascritps/interpreter"
task :build_skulpt do
     #make temp versions of builtin.js and builtindict.js to whcih we will append  our additons
     system('(cd skulpt;mv base/src/builtin.js builtin_original)')
     system('(cd skulpt;mv base/src/builtindict.js builtindict_original)')

     #append our additons temporary files
     system('(cd skulpt; cp builtin_original builtin.js; cp builtindict_original builtindict.js)')
     system('(cd skulpt; cat ext/paths.js >> builtin.js)')
     system('(cd skulpt; cat ext/builtin_ext.js >> builtin.js)')
     system('(cd skulpt; cat ext/builtindict_ext.js >> builtindict.js)')
     system('(cd skulpt; mv builtin.js base/src/builtin.js; mv builtindict.js base/src/builtindict.js)')

     #build
     system('(cd skulpt/base; python m dist)')

     #grab interpreter files and move them to assets 
     system('(cp skulpt/base/dist/skulpt.min.js app/assets/javascripts/interpreter/skulpt.min.js)')
     system('(cp skulpt/base/dist/skulpt-stdlib.js app/assets/javascripts/interpreter/skulpt-stdlib.js)')

     #move original files back into base folder
     system('(cd skulpt/base/src; rm builtin.js builtindict.js)')
     system('(cd skulpt; mv builtin_original base/src/builtin.js; mv builtindict_original base/src/builtindict.js)')

end
