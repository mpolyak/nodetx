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

exports.TxOut = class TxOut
	constructor: (@value = 0, @script = new Buffer 0) ->

	serialize: ->
		new Binary.Writer()
			.int64	@value
			.varstr @script
			.buffer

	deserialize: (buffer) ->
		reader = if buffer instanceof Binary.Reader
			buffer
		else
			new Binary.Reader buffer

		@value = reader.int64()
		@script = reader.varstr()