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
bignum = require "bignum"

BASE58 = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

exports.base58 = base58 = (buffer) ->
	x = bignum.fromBuffer buffer

	string = []

	while x.gt 0
		r = x.mod 58
		x = x.div 58

		string.push BASE58[r.toNumber()]

	i = 0

	while buffer[i] is 0
		string.push BASE58[0]

		++ i

	string.reverse().join ""

exports.sha256 = sha256 = (buffer) ->
	crypto.createHash("sha256").update(buffer).digest().slice 0

exports.hash = hash = (buffer, reverse = false) ->
	buffer = sha256(sha256 buffer)

	if reverse
		buffer = new Buffer (
			byte for byte in buffer).reverse()

	buffer

exports.hashToAddress = hashToAddress = (buffer, prefix) ->
	buffer = Buffer.concat [
		new Buffer([prefix]), buffer]

	base58 Buffer.concat([buffer, hash(buffer).slice(0, 4)])