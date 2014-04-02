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

net = require "net"

{Address} = require "./protocol/address"
{Version} = require "./protocol/version"
{Verack}  = require "./protocol/verack"
{Inv}	  = require "./protocol/inv"
{Tx}	  = require "./protocol/tx"
{Block}	  = require "./protocol/block"
{Command} = require "./protocol/command"
{Script}  = require "./protocol/script"

Crypto = require "./utils/crypto"

debug = (args...) ->
	console.log "#{(new Date).toLocaleTimeString()}: #{args}"

HOST = "127.0.0.1"
PORT = 8333

if process.argv.length > 2
	if process.argv.length > 2
		HOST = process.argv[2]

	if process.argv.length > 3
		PORT = process.argv[3]
else
	console.log "Usage: #{process.argv[0]} #{process.argv[1]} <NODE IP> [NODE PORT]"

debug "connect #{HOST}:#{PORT}"

socket = net.connect {host: HOST, port: PORT}, ->
	debug "connected"

	command = new Command "version", (new Version new Address(HOST, PORT)).serialize()

	debug "send version"

	socket.write command.serialize()

socket.on "error", (error) ->
	debug error

socket.on "end", ->
	debug "disconnected"

buffer = new Buffer 0

socket.on "data", (data) ->
	buffer = Buffer.concat [buffer, data]

	commands = []

	while command = Command.find buffer
		commands.push buffer.slice(command.start, command.end)

		buffer = buffer.slice command.end

	unless commands.length or buffer.length < 1000000
		throw new Error "MAX BUFFER"

	for data in commands
		command = new Command

		command.deserialize data

		if command.name
			handle command

handle = (command) ->
	switch command.name
		when "version"
			version = new Version

			version.deserialize command.payload

			debug "recv version #{version.useragent} #{version.version}, #{version.services}, #{version.height}, #{(new Date version.time * 1000).toString()}"

			command = new Command "verack", (new Verack).serialize()

			debug "send verack"

			socket.write command.serialize()

		when "inv", "getdata"
			inv = new Inv

			inv.deserialize command.payload

			###
			debug "recv #{command.name} #{inv.inv.length}"
			###

			inv = (inv for inv in inv.inv when inv.type isnt 0)

			if inv.length
				command = new Command "getdata", (new Inv inv).serialize()

				###
				debug "send getdata #{inv.length}"
				###

				socket.write command.serialize()

		when "tx"
			tx = new Tx

			tx.deserialize command.payload

			transaction tx

		when "block"
			block = new Block

			block.deserialize command.payload

			debug "recv block #{block.txns.length}"

			for tx in block.txns
				transaction tx

		else
			debug "recv #{command.name}"

transaction = (tx) ->
	debug "recv tx #{Crypto.hash(tx.serialize(), true).toString "hex"}"

	for o in tx.outs
		script = new Script o.script, false

		if script.hash.length
			debug "\t  #{Math.floor(o.value / 1000) / 100000} BTC\t#{Crypto.hashToAddress script.hash, script.prefix}"
			
