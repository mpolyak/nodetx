assert = require "assert"

{Script} = require "../coffee/protocol/script"

describe "Script", ->
	script = new Script new Buffer("76A914000000000000000000000000000000000000000088AC", "hex"), false

	it "script hash should be 20 bytes long", ->
		assert.equal 20, script.hash.length

	it "script hash should be zero", ->
		i = 0

		while i < script.hash.length
			assert.equal 0, script.hash[i]

			++ i
