async = require 'async'

# Base class inherited by all reporters. This class handles
# basic validation and the default flow to construct and output
# results. All reporters are expected to override one or all of
# the functions below.

class Reporter

  constructor: (@options, @callback) ->
    
    unless @options?.data
      return @callback new Error('No data input to reporter')

    @run()

  # The basic control flow for all reporters. Each reporter will
  # synchronously map it's data, format that data for output and 
  # then print that output. The output will be suppressed if 
  # the silent flag is set, but it can always be returned via
  # callback if specfied.
  run: =>
    
    async.series [
      @map
      @format
      @print
    ], (err) =>
      @callback err, @output if @callback

  # Map the results data to the structure desired for output.
  map: (callback) =>

    @data = @options.data
    callback()

  # Format the data as a string to be output.
  format: (callback) =>

    return callback() unless @data

    @output = @data.toString()
    callback()

  # Output the string data, unless the silent flag is set.
  print: (callback) =>

    return callback() if @options.silent or !@data

    console.log @output
    callback()

module.exports = Reporter