assert    = require 'assert'
fs        = require 'fs'
reporters = require '../lib/reporters/show'
util      = require 'util'
output    = require './test_output_show.json'

describe 'Show reporters', ->

  it 'should have a basic reporter', ->
    assert reporters.basic
    assert reporters.basic.description

  it 'should have a thread reporter', ->
    assert reporters.thread
    assert reporters.thread.description

  it 'should return an error if no data is specfied', (done) ->
    reporters.basic {}, (err, data) ->
      assert err
      done()

describe 'Basic reporter (show)', ->

  it 'should print data', (done) ->
    reporters.basic {data: output, silent: true}, (err, results) ->
      assert.ifError err
      assert.notEqual results.indexOf('Test test test '), -1
      done()

describe 'Thread reporter (show)', ->

  it 'should print data', (done) ->
    reporters.thread {data: output, silent: true}, (err, results) ->
      assert.ifError err
      assert.notEqual results.indexOf('Test test test'), -1
      assert.notEqual results.indexOf('Test2 test2 test2'), -1
      done()
