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
Crypto = require "../utils/crypto"

exports.Command = class Command
	@magic = new Buffer [0xF9, 0xBE, 0xB4, 0xD9]

	@find: (buffer) ->
		index = 0

		while index + 20 <= buffer.length
			reader = new Binary.Reader buffer.slice(index)

			if equal @magic, reader.get(4)
				reader.skip 12

				length = reader.uint32()

				if reader.position + 4 + length <= buffer.length
					return start: index, end: index + reader.position + 4 + length
				else
					return null
			else
				++ index

		null

	constructor: (@name = "", @payload = new Buffer 0) ->

	serialize: ->
		name = new Buffer @name, "ascii"

		new Binary.Writer()
			.put 	Command.magic
			.put 	name
			.pad 	12 - name.length
			.uint32	@payload.length
			.put 	Crypto.hash(@payload).slice 0, 4
			.put 	@payload
			.buffer

	deserialize: (buffer) ->
		@name = ""; @payload = new Buffer 0

		if buffer.length < 20
			return

		reader = new Binary.Reader buffer

		unless equal Command.magic, reader.get(4)
			return

		@name = reader.get(12).slice(0, 12).toString("ascii").replace /\0+$/, ""

		if length = reader.uint32()
			checksum = reader.get 4
			@payload = reader.get length

			unless equal checksum, Crypto.hash(@payload).slice(0, 4)
				@name = ""; @payload = new Buffer 0

	equal = (a, b) ->
		if a.length isnt b.length
			return false

		i = 0

		while i < a.length
			return false if a[i] isnt b[i]

			++ i

		true