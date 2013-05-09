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

  it 'should have a create function', ->
    assert tenderCLI(program, {}).create

  it 'should have a reply function', ->
    assert tenderCLI(program, {}).reply

  it 'should have an ack function', ->
    assert tenderCLI(program, {}).ack

  it 'should have a resolve function', ->
    assert tenderCLI(program, {}).resolve

  it 'should have a reopen function', ->
    assert tenderCLI(program, {}).reopen

  it 'should have a queue function', ->
    assert tenderCLI(program, {}).queue

  it 'should have an unqueue function', ->
    assert tenderCLI(program, {}).unqueue

  it 'should have a categorize function', ->
    assert tenderCLI(program, {}).categorize

  it 'should have a remove function', ->
    assert tenderCLI(program, {}).remove

  it 'should have a restore function', ->
    assert tenderCLI(program, {}).restore

  it 'should have a toggle function', ->
    assert tenderCLI(program, {}).toggle

  it 'should load configuration data from a file', ->
    if fs.existsSync path.join(process.env.HOME || process.env.HOMEPATH, '.tenderrc')
      cli = tenderCLI(program, {})
      assert cli.clientOpts.username or cli.clientOpts.token
      assert cli.clientOpts.subdomain
