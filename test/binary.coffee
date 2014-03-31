assert = require "assert"

Binary = require "../coffee/utils/binary"

describe "Binary", ->
	describe "word", ->
		list = [8, 16, 32, 64]

		writer = new Binary.Writer

		for bits in list
			writer["int#{bits}"] bits

		reader = new Binary.Reader writer.buffer

		for bits in list
			do (bits) ->
				it "int#{bits}() should equal #{bits}", ->
					assert.equal bits, reader["int#{bits}"]()

	describe "varint", ->
		list = [7, 15, 31, 63]

		writer = new Binary.Writer

		for bits in list
			writer.varint Math.pow 2, bits

		reader = new Binary.Reader writer.buffer

		for bits in list
			do (bits) ->
				value = Math.pow 2, bits

				it "2^#{bits} should equal #{value}", ->
					assert.equal value, reader.varint()

	describe "varstr", ->
		phrase = "The Quick Brown Fox Jumps Over The Lazy Dog"

		writer = new Binary.Writer()
			.varstr phrase

		reader = new Binary.Reader writer.buffer

		it "should equal #{phrase}", ->
			assert phrase, reader.varstr().toString "ascii"

