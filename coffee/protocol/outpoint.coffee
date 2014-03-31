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

exports.OutPoint = class OutPoint
	constructor: (@hash = new Buffer(32), @index = 0) ->

	serialize: ->
		new Binary.Writer()
			.put	@hash
			.uint32	@index
			.buffer

	deserialize: (buffer) ->
		reader = new Binary.Reader buffer

		@hash  = reader.get 32
		@index = reader.uint32()