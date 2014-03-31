assert = require "assert"

{Address} = require "../coffee/protocol/address"

describe "Address", ->
	address = new Address

	address.deserialize (new Address "127.0.0.1", 8333).serialize()

	it "ip should equal 127.0.0.1", ->
		assert.equal "127.0.0.1", address.ip

	it "port should equal 8333", ->
		assert.equal 8333, address.port