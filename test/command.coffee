assert = require "assert"

{Command} = require "../coffee/protocol/command"

describe "Command", ->
	command = new Command

	command.deserialize (new Command "test", new Buffer "test", "ascii").serialize()

	it "name should equal test", ->
		assert.equal "test", command.name

	it "payload should equal test", ->
		assert.equal "test", command.payload.toString "ascii"



