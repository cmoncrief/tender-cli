fs       = require 'fs'
Reporter = require '../reporter'

# Outputs a JSON file with all fields returned by the Tender API.

class JSONReporter extends Reporter

  format: (callback) =>
    @output = JSON.stringify(@data, null, 2)
    callback()

  print: (callback) =>

    return callback() unless @data

    file = @options?.cmdOptions?.output || "tender_output.json"

    fs.writeFile file, @output, =>
      unless @options.silent
          console.log "#{@data.length} records exported to #{file}"
      callback()

module.exports = (options, callback) ->
  new JSONReporter(options, callback)

module.exports.description = "Exports JSON file with all fields"