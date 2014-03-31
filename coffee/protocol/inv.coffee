###
#
# NodeTX - Bitcoin P2P Transaction Monitor
#
# Copyright (c) 2014 Michael Polyak. All rights reserved.
# https://github.com/mpolyak/nodetx
#
# Distributed under the MIT software license, see the accompanying file LICENSE
#
###

Binary = require "../utils/binary"

exports.Inv = class Inv
	constructor: (@inv = []) ->

	serialize: ->
		writer = new Binary.Writer

		writer.varint @inv.length

		for inv in @inv
			writer.uint32 inv.type
			writer.put	  inv.hash

		writer.buffer

	deserialize: (buffer) ->
		reader = new Binary.Reader buffer

		count = reader.varint()

		@inv = (while count
			-- count

			type: reader.uint32()
			hash: reader.get 32)

