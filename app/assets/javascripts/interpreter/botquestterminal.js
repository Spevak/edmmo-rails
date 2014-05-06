//Modified from Skulpt's repl.js 
//By Kevin Spevak
$(function () {
    var repl = new CodeMirrorREPL('interactive', {
            mode: "python",
            theme: "solarized dark"
        }),

        //Add some botquest constants
    compilableLines = ["north = 'north'", "south = 'south'", "east = 'east'", "west = 'west'"],

        //finds lines starting with "print" 
        re = new RegExp("\\s*print"),
        //finds import statements
        importre = new RegExp("\\s*import"),
        //finds multuline string constants
        mls = new RegExp("'''"),
        //finds defining statements
        defre = new RegExp("def.*|class.*"),
        //test for empty line.
        emptyline = new RegExp("^\\s*$");

    //finds assignment operators but not comparison operators
    assre = /[^=!]=(?!=)/;
    
    //matches a line containing a botquest builtin
    bqBuiltin = /go.*|pickup.*|drop.*|useItem.*|status.*|inspect.*|characters.*|tiles.*|dig.*/g

    repl.print("This is a terminal. You can enter commands here.");
    repl.print("To see where you are on the map the left, try typing look()")
    repl.isBalanced = function (code) {
        var lines = code.split('\n'),
            depth = 0,
            mlsopened = false;
        
        for (var l in lines){
            if (lines[l].match(/'''/) !== null && lines[l].match(/'''/).length == 1) {
                mlsopened = !mlsopened;
            }
            if (!mlsopened && lines[l].substr(lines[l].length -1) == ":") {
                depth++;
            }
            if (!mlsopened && lines[l] == "" && depth > 0){
                depth--;
            }
        }
        return depth == 0 && !mlsopened;
    }

    //Loop
    repl.eval = function (code) {
        Sk.configure({ 
            output: function(str) {
                //strip out line-feeds
                if (str.replace(/\n/g, "") != ""){
                    repl.print(str);
                }
            }, 
            read: function (x) {
                if (Sk.builtinFiles === undefined || Sk.builtinFiles["files"][x] === undefined)
                    throw "File not found: '" + x + "'";
                return Sk.builtinFiles["files"][x];
            }
        });

        //load in local vars
        var locals = []
	var localVarNames = Object.keys(Bq.localVars);
	for (i = 0; i < localVarNames.length; i++) {
	    var varname = localVarNames[i];
	    locals.push(varname + " = loadLocalVar('" + varname + "')");
	}
        var linesToCompile = compilableLines.concat(locals);


        //split lines on linefeed
        var lines = code.split('\n');
        lines = lines.filter(function(str) { return !emptyline.test(str); });

        //concatenate them to the lines collected up till now
        linesToCompile = linesToCompile.concat(lines);

        console.log(linesToCompile);

        //it's a onliner
        if (lines.length == 1) {
            //if it's a statement that should be printed (not containing an = or def or class or an empty line)
            if (!assre.test(lines[0]) && !defre.test(lines[0]) && !importre.test(lines[0]) && lines[0].length > 0) {
                //if it doesn't contain print make sure it doesn't print None
                if (!re.test(lines[0])) {
                    //remove the statement
                    linesToCompile.pop();
                    //evaluate it if nessecary
                    linesToCompile.push("evaluationresult = " + lines[0]);
                    //print the result if not None
                    linesToCompile.push("if not evaluationresult == None: print evaluationresult");
                }
                //make sure it doesnt' end up in the list with lines to compile the next run
                lines.pop();
            }
	    //assignment, so we should save to local scope
	    else if (assre.test(lines[0])) {
		//find the name of the var from the assignment
		var varName = lines[0].substring(0, lines[0].indexOf('=')).trim();
		//Just need to give it some value so it will show up in the keys and we will remember to store
                //the value at the end of evaluation
		if (!Bq.localVars[varName]) {
		    Bq.localVars[varName] = "";
		}
		//don't need to recompile the assignments every time now that we're putting it in the local scope
		lines.pop();
						 
	    }
        }        
        
        //filter out empty lines
        lines = lines.filter(function(str){ return !emptyline.test(str); });
        
        //don't compile if there isn't anything to compile.
        if (linesToCompile.length === 0) { return; }

	//at the end we want to save all the variables to the local scope
	var saves = []
	localVarNames = Object.keys(Bq.localVars);
	for (i = 0; i < localVarNames.length; i++) {
	    var varname = localVarNames[i];
	    saves.push("saveLocalVar(" + varname + ", '" + varname + "')");
	}
        var linesToCompile = linesToCompile.concat(saves);
        
        try {
            //Evaluate
            Sk.importMainWithBody("repl", false, linesToCompile.join('\n'));
            //remove print statements when a block is created that doesn't define anything
            var removePrints = false;
            compilableLines = compilableLines.concat(lines.map(function (str) {
                //non defining block statement
                if (str.substr(str.length -1) == ":" && !defre.test(str)) {
                    removePrints = true;
                    return str;
                }
            
                //end of non defining block statement
                if(str == "" && removePrints){
                    removePrints = false;
                    return str;
                }
                
		//Remove bq builtins the same way prints are removed
		if (bqBuiltin.test(str) && removePrints) {
		    return str.replace(bqBuiltin, "pass");
		}

                if (re.test(str) && removePrints) {
                    //strip prints from non defining block statements.
                    return str.replace(/print.*/g, "pass");
                } else {
                    return str;
                }
            }));
        } catch (err) {
            repl.print(err);

            var index = -1;
            //find the line number
            if ((index = err.toString().indexOf("on line")) != -1) {
                index = parseInt(err.toString().substr(index + 8), 10);
            }
            var line = 0;
            //print the accumulated code with a ">" before the broken line.
            //Don't add the last statement to the accumulated code
            repl.print(linesToCompile.map(function (str) {
                return ++line + (index == line ? ">" : " ") + ": " + str;
            }).join('\n'));
        }
    }
});