assert    = require 'assert'
fs        = require 'fs'
path      = require 'path'
tenderCLI = require '../lib/tender-cli'

program = {token: '12345'}

describe 'Command', ->

  it 'should create a CLI object sanely', ->
    assert tenderCLI(program, {})

  it 'should have a list function', ->
    assert tenderCLI(program, {}).list

  it 'should have a show function', ->
    assert tenderCLI(program, {}).show

  it 'should load configuration data from a file', ->
    if fs.existsSync path.join process.env.HOME, '.tenderrc'
      cli = tenderCLI(program, {})
      assert cli.clientOpts.username or cli.clientOpts.token
      assert cli.clientOpts.subdomain
