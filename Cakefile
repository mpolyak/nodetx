{exec} = require 'child_process'

files =
[
	"coffee/utils/binary.coffee"
	"coffee/utils/crypto.coffee"
	"coffee/protocol/address.coffee"
	"coffee/protocol/version.coffee"
	"coffee/protocol/verack.coffee"
	"coffee/protocol/inv.coffee"
	"coffee/protocol/tx.coffee"
	"coffee/protocol/txin.coffee"
	"coffee/protocol/outpoint.coffee"
	"coffee/protocol/txout.coffee"
	"coffee/protocol/block.coffee"
	"coffee/protocol/command.coffee"
	"coffee/protocol/script.coffee"
	"coffee/main.coffee"
]

task "sbuild", "build everything", ->
  for file in files
  	console.log file

  	exec "coffee -c #{file}", (error, stdout, stderr) ->
    	throw error if error

 task "test", "run tests", ->
 	exec "NODE_ENV=test
 		./node_modules/.bin/mocha
 		--compilers coffee:coffee-script/register
 		--reporter list
 		--require coffee-script
 		--colors
 		", (error, stdout, stderr) ->
 			if stderr
 				console.log stderr

 			console.log stdout