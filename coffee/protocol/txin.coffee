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

{OutPoint} = require "./outpoint"

Binary = require "../utils/binary"

exports.TxIn = class TxIn
	constructor: (@prevout = new OutPoint) ->
		@script = new Buffer 0
		@sequence = 0

	serialize: ->
		new Binary.Writer()
			.put 	@prevout.serialize()
			.varstr	@script
			.uint32	@sequence
			.buffer

	deserialize: (buffer) ->
		reader = if buffer instanceof Binary.Reader
			buffer
		else
			new Binary.Reader buffer

		@prevout.deserialize reader.get 36

		@script = reader.varstr()
		@sequence = reader.uint32()

