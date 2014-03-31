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

crypto = require "crypto"

{Address} = require "./address"

Binary = require "../utils/binary"

exports.Version = class Version
	constructor: (@to = new Address, @from = new Address) ->
		@version   = 312
		@services  = 1
		@useragent = "/nodetx:0.1.0/"
		@height    = -1
		@nonce 	   = crypto.randomBytes(8).slice 0
		@time 	   = Math.floor (new Date).getTime() / 1000

	serialize: ->
		new Binary.Writer()
			.int32	@version
			.uint64	@services
			.int64	@time
			.put 	@to.serialize()
			.put 	@from.serialize()
			.put 	@nonce
			.varstr @useragent
			.int32 	@height
			.buffer

	deserialize: (buffer) ->
		reader = new Binary.Reader buffer

		@version  = reader.int32()
		@services = reader.uint64()
		@time 	  = reader.int64()

		@to.deserialize	  reader.get 26
		@from.deserialize reader.get 26

		@nonce 	   = reader.get 8
		@useragent = reader.varstr().toString "ascii"
		@height    = reader.int32()