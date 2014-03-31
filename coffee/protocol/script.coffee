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

exports.Script = class Script
	@OP_DUP			= 0x76
	@OP_EQUAL 		= 0x87
	@OP_EQUALVERIFY = 0x88
	@OP_HASH160		= 0xA9
	@OP_CHECKSIG	= 0xAC

	constructor: (buffer, signature) ->
		@r 		= new Buffer 0
		@s 		= new Buffer 0
		@hash 	= new Buffer 0
		@pubkey = new Buffer 0

		@prefix = 0

		unless buffer.length
			return

		if signature
			if buffer.length and buffer[0] < buffer.length and buffer[buffer[0]] is 1 and buffer[1] is 48 and buffer[buffer[2] + 3] is 1
				if buffer[3] is 2
					index = 5 + buffer[4]

					if buffer[index] is 2 and buffer[index + 1 + buffer[index + 1] + 1] is 1
						@r = buffer.slice 		  5, index
						@s = buffer.slice index + 2, index + 2 + buffer[index + 1]
		else
			switch buffer.length
				when 23
					if buffer[0] is Script.OP_HASH160 and buffer[1] is 20 and buffer[22] is Script.OP_EQUAL
						@prefix = 5; @hash = buffer.slice 2, 22

				when 25
					if buffer[0] is Script.OP_DUP and buffer[1] is Script.OP_HASH160 and buffer[2] is 20 and buffer[23] is Script.OP_EQUALVERIFY and buffer[24] is Script.OP_CHECKSIG
						@prefix = 0; @hash = buffer.slice 3, 23

				when 35
					if buffer[0] is 33 and buffer[34] is Script.OP_CHECKSIG and (buffer[1] is 2 or buffer[1] is 3)
						@pubkey = buffer.slice 1, 34

				when 67
					if buffer[0] is 65 and buffer[66] is Script.OP_CHECKSIG and buffer[1] is 4
						@pubkey = buffer.slice 1, 66