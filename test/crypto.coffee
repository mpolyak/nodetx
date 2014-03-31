assert = require "assert"

Crypto = require "../coffee/utils/crypto"

describe "Crypto", ->
	address = "1111111111111111111114oLvT2"

	it "hash address should equal #{address}", ->
		assert.equal address, Crypto.hashToAddress(new Buffer([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]), 0)