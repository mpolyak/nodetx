assert = require "assert"

{Version} = require "../coffee/protocol/version"

describe "Version", ->
	version = new Version

	version.deserialize (new Version).serialize()

	it "version should equal 312", ->
		assert.equal 312, version.version

	it "useragent should equal /nodetx:0.1.0/", ->
		assert.equal "/nodetx:0.1.0/", version.useragent

	it "height should equal -1", ->
		assert.equal -1, version.height