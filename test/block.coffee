assert = require "assert"

{Tx} 	= require "../coffee/protocol/tx"
{Block} = require "../coffee/protocol/block"

describe "Block", ->
	block = new Block

	block.deserialize (new Block [new Tx, new Tx, new Tx]).serialize()

	it "txns should equal 3", ->
		assert.equal 3, block.txns.length