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

{TxIn} = require "./txin"
{TxOut} = require "./txout"

Binary = require "../utils/binary"

exports.Tx = class Tx
	constructor: (@ins = [new TxIn], @outs = [new TxOut]) ->
		@version = 1
		@locktime = 0

	serialize: ->
		writer = new Binary.Writer()

		writer.uint32 @version

		writer.varint @ins.length

		for i in @ins
			writer.put i.serialize()

		writer.varint @outs.length

		for o in @outs
			writer.put o.serialize()

		writer.uint32 @locktime

		writer.buffer

	deserialize: (buffer) ->
		reader = if buffer instanceof Binary.Reader
			buffer
		else
			new Binary.Reader buffer

		@version = reader.uint32()

		count = reader.varint()

		@ins = (while count
			-- count

			txin = new TxIn
			txin.deserialize reader

			txin)

		count = reader.varint()

		@outs = (while count
			-- count

			txout = new TxOut
			txout.deserialize reader

			txout)

		@locktime = reader.uint32()