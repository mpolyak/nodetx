assert = require "assert"

{Tx} = require "../coffee/protocol/tx"

describe "Tx", ->
	tx = new Tx

	tx.deserialize (new Tx).serialize()

	it "version should equal 1", ->
		assert.equal 1, tx.version

	it "locktime should equal 0", ->
		assert.equal 0, tx.locktime