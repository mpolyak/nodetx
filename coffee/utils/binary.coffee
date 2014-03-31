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

exports.Reader = class Reader
	constructor: (@buffer) ->
		@position = 0

		for bytes in [1, 2, 4, 8]
			@["uint#{bytes * 8}"] = do (bytes) ->
				->
					uint @get bytes

			@["int#{bytes * 8}"] = do (bytes) ->
				->
					int @get bytes

	get: (bytes) ->
		if @position + bytes > @buffer.length
			throw new Error "EOF"

		@buffer.slice @position, @position += bytes

	skip: (bytes) ->
		if @position + bytes > @buffer.length
			throw new Error "EOF"

		@position += bytes

	varint: ->
		switch byte = @uint8()
			when 0xFD then @uint16()
			when 0xFE then @uint32()
			when 0xFF then @uint64()
			else byte

	varstr: ->
		@get @varint()

	uint = (bytes) ->
		value = i = 0

		while i < bytes.length
			value += Math.pow(256, i) * bytes[i]

			++ i

		value

	int = (bytes) ->
		value = uint bytes

		if (bytes[bytes.length - 1] & 0x80) is 0x80
			value -= Math.pow 256, bytes.length

		value

exports.Writer = class Writer
	constructor: ->
		@buffer = new Buffer 0

		for bytes in [1, 2, 4, 8]
			@["uint#{bytes * 8}"] = @["int#{bytes * 8}"] = do (bytes) ->
				(value) ->
					@buffer = Buffer.concat [@buffer
						new Buffer uint(value, bytes)]

					@

	put: (buffer) ->
		@buffer = Buffer.concat [@buffer
			buffer]

		@

	pad: (bytes) ->
		buffer = new Buffer bytes
		
		buffer.fill 0

		@buffer = Buffer.concat [@buffer
			buffer]

		@
		
	varint: (value) ->
		switch
			when value < 0xFD     then @uint8 			   value
			when value <= 1 << 16 then @uint8(0xFD).uint16 value
			when value <= 1 << 32 then @uint8(0xFE).uint32 value
			else 				   	   @uint8(0xFF).uint64 value

	varstr: (value) ->
		@varint(value.length).put new Buffer(value, "ascii")

	uint = (value, bytes) ->
		i = 0

		while i < bytes
			bits = i * 8; ++ i

			if bits >= 32
				Math.floor(value / Math.pow(2, bits)) & 0xFF
			else
				(value >> bits) & 0xFF