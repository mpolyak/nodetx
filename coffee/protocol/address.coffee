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

exports.Address = class Address
	constructor: (@ip = "0.0.0.0", @port = 0) ->
		@services = 1
		@reserved = new Buffer [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF, 0xFF]

	serialize: ->
		new Binary.Writer()
			.uint64 @services
			.put 	@reserved
			.uint32 inet_aton @ip
			.uint16 htons @port
			.buffer

	deserialize: (buffer) ->
		reader = new Binary.Reader buffer

		@services = reader.uint64()
		@reserved = reader.get 12
		@ip 	  = inet_ntoa reader.uint32()
		@port 	  = ntohs reader.uint16()

	inet_aton = (a) ->
		a = a.split "."

		((a[3] << 24) >>> 0) +
		((a[2] << 16) >>> 0) +
		((a[1] <<  8) >>> 0) +
		 (a[0] >>> 0)

	inet_ntoa = (n) ->
		((n      ) & 0xFF) + "." +
		((n >>  8) & 0xFF) + "." +
		((n >> 16) & 0xFF) + "." +
		((n >> 24) & 0xFF) 

	htons = (h) ->
		(h << 8) + ((h >> 8) & 0xFF)

	ntohs = (n) ->
		((n & 0xFF) << 8) + (n >> 8)