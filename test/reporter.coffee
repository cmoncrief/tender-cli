assert    = require 'assert'
fs        = require 'fs'
reporters = require '../lib/reporters'
util      = require 'util'
output    = require './test_output.json'

describe 'Reporters', ->

  it 'should have a basic reporter', ->
    assert reporters.basic
    assert reporters.basic.description

  it 'should have a csv reporter', ->
    assert reporters.csv
    assert reporters.csv.description

  it 'should have a full csv reporter', ->
    assert reporters.csvfull
    assert reporters.csvfull.description

  it 'should have a list reporter', ->
    assert reporters.list
    assert reporters.list.description

  it 'should have a table reporter', ->
    assert reporters.table
    assert reporters.table.description

  it 'should return an error if no data is specfied', (done) ->
    reporters.basic {}, (err, data) ->
      assert err
      done()

describe 'Basic reporter', ->

  it 'should print data', (done) ->
    reporters.basic {data: output, silent: true}, (err, results) ->
      assert.ifError err
      assert.equal results, "\n(1) discussions: \n\n#123: Test 123\n"
      done()

describe 'List reporter', ->

  it 'should print data', (done) ->
    reporters.list {data: output, silent: true}, (err, results) ->
      assert.ifError err
      assert results
      assert.notEqual results.indexOf("Displaying (1) discussions:"), -1
      assert.notEqual results.indexOf("Discussion #123"), -1
      done()

describe 'Table reporter', ->

  it 'should print data', (done) ->
    reporters.table {data: output, silent: true}, (err, results) ->
      assert.ifError err
      assert.notEqual results.indexOf("Id"), -1
      done()

describe 'CSV reporter', ->

  it 'should print csv data to file', (done) ->
    reporters.csv {data: output, cmdOptions : {output: './test/test.csv'}, silent: true}, (err, results) ->
      assert.ifError err
      assert.notEqual results.indexOf('number,title,author_name,state,age'), -1
      assert fs.existsSync './test/test.csv'
      fs.unlinkSync './test/test.csv'
      done()

describe 'Full CSV reporter', ->

  it 'should print csv data to file', (done) ->
    reporters.csvfull {data: output, cmdOptions : {output: './test/test_full.csv'}, silent: true}, (err, results) ->
      assert.ifError err
      assert.notEqual results.indexOf('id,number,title,author_name,author_email,state,age,public,hidden,unread,unresponded,comments_count,watchers_count,last_user_id,last_updated_at,last_via,last_author_email,last_author_name,href'), -1
      assert fs.existsSync './test/test_full.csv'
      fs.unlinkSync './test/test_full.csv'
      done()

describe 'JSON reporter', ->

  it 'should print json data to file', (done) ->
    reporters.json {data: output, cmdOptions : {output: './test/test.json'}, silent: true}, (err, results) ->
      assert.ifError err
      assert.notEqual results.indexOf('"category_href": "https://api.tenderapp.com:443/",'), -1
      assert fs.existsSync './test/test.json'
      fs.unlinkSync './test/test.json'
      done()
