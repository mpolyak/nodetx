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

{Tx} = require "./tx"

Binary = require "../utils/binary"

exports.Block = class Block
	constructor: (@txns = []) ->
		@version = @timestamp = @bits = @nonce = 0

		@prevblock = new Buffer 32
		@merkleroot = new Buffer 32

	serialize: ->
		writer = new Binary.Writer()
			.uint32	@version
			.put	@prevblock
			.put	@merkleroot
			.uint32 @timestamp
			.uint32 @bits
			.uint32 @nonce

		writer.varint @txns.length

		for tx in @txns
			writer.put tx.serialize()

		writer.buffer

	deserialize: (buffer) ->
		reader = new Binary.Reader buffer

		@version 	= reader.uint32()
		@prevblock	= reader.get 32
		@merkleroot	= reader.get 32
		@timestamp	= reader.uint32()
		@bits		= reader.uint32()
		@nonce		= reader.uint32()

		count = reader.varint()

		@txns = (while count
			-- count

			tx = new Tx
			tx.deserialize reader

			tx)