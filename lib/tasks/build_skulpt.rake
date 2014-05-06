desc "Builds the interpreter from skulpt source and puts the resulting javascript files into app/assets/javascritps/interpreter"
task :build_skulpt do

  trap('INT') do
    puts "STOPPED rake build_skulpt: Caught SIGINT. Cleaning up skulpt directory."
    #move original files back into base folder
    system('rm -rf skulpt && cp -r skulpt_backup skulpt')
    puts "Cleaning process complete."
  end

  #Check if building for test or production API
  testing = ENV['testing']
  if testing
    puts('Using test API')
  else
    puts('Using production API') 	
  end

  # backup initial directory state
  system('cp -r skulpt skulpt_backup');

  #make temp versions of env.js, builtin.js, and builtindict.js to whcih we will append  our additons
  system('(cd skulpt;mv base/src/env.js env_original)')
  system('(cd skulpt;mv base/src/builtin.js builtin_original)')
  system('(cd skulpt;mv base/src/builtindict.js builtindict_original)')
  #easier to append our additional builtin types into object rather than
  #in separate files because separate files requires editing the build script
  #system('(cd skulpt;mv base/src/object.js object_original)')

  #append our additons temporary files
  system('(cd skulpt; cp env_original env.js; cp object_original object.js)')
  system('(cd skulpt; cp builtin_original builtin.js; cp builtindict_original builtindict.js)')
  #append the appropriate path file depending on if using test or production API
  if testing
    system('(cd skulpt; cat ext/test_paths.js >> env.js)')
  else
    system('(cd skulpt; cat ext/paths.js >> env.js)')
  end
  system('(cd skulpt; cat ext/bq.js >> env.js)')
  system('(cd skulpt; cat ext/constants.js >> env.js)')
  system('cat config/map/tiles/properties_prefix >>  skulpt/env.js')
  system('cat config/map/tiles/properties.json >> skulpt/env.js')
  system('(cd skulpt; cat ext/env_ext.js >> env.js)')
  system('(cd skulpt; cat ext/builtin_ext.js >> builtin.js)')
  system('(cd skulpt; cat ext/item.js >> builtindict.js)')
  system('(cd skulpt; cat ext/builtindict_ext.js >> builtindict.js)')

  system('(cd skulpt; mv env.js base/src/env.js)')
  #system('(cd skulpt; mv env.js base/src/env.js; mv object.js base/src/object.js)')
  system('(cd skulpt; mv builtin.js base/src/builtin.js; mv builtindict.js base/src/builtindict.js)')

  #build
  system('(cd skulpt/base; python m dist)')

  #grab interpreter files and constants file and move them to assets.
  system('(cp skulpt/base/dist/skulpt.min.js app/assets/javascripts/interpreter/skulpt.min.js)')
  system('(cp skulpt/base/dist/skulpt-stdlib.js app/assets/javascripts/interpreter/skulpt-stdlib.js)')
  system('(cp skulpt/ext/constants.js app/assets/javascripts)')

  #move original files back into base folder
  #system('(cd skulpt/base/src; rm env.js builtin.js builtindict.js object.js)')
  system('(cd skulpt/base/src; rm env.js builtin.js builtindict.js)')

  system('(cd skulpt; mv env_original base/src/env.js)')
  system('(cd skulpt; mv builtin_original base/src/builtin.js)')
  system('(cd skulpt; mv builtindict_original base/src/builtindict.js)')
  #system('(cd skulpt; mv object_original base/src/object.js)')
  system('rm -rf skulpt_backup')

end
