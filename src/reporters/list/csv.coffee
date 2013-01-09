path     = require 'path'
moment   = require 'moment'
csv      = require 'csv'
Reporter = require '../../reporter'

# Outputs a CSV file with the same fields found in the default table
# reporter.

class CSVReporter extends Reporter

  map: (callback) =>
    @data = []
    header = {}

    for i in @options.data
      created = moment i.created_at
      @data.push
        number      : i.number
        title       : i.title
        author_name : i.author_name 
        state       : i.state
        age         : created.fromNow(true)

    header[key] = key for key of @data[0]
    @data.unshift header

    callback()

  print: (callback) =>
    return callback() unless @data

    file = @options?.cmdOptions?.output || "tender_output.csv"

    csv()
      .from(@data)
      .to.path(path.join(process.cwd(), file))
      .to((data) => @output = data)
      .on 'end', (count) =>
        unless @options.silent
          console.log "#{count} records exported to #{file}"
        callback()

module.exports = (options, callback) ->
  new CSVReporter(options, callback)

module.exports.description = "Exports csv file with minimal fields"