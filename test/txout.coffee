assert = require "assert"

{TxOut} = require "../coffee/protocol/txout"

describe "TxOut", ->
	out = new TxOut

	out.deserialize (new TxOut 50).serialize()

	it "value should equal 50", ->
		assert.equal 50, out.value