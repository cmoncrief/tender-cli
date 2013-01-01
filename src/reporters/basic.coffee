Reporter = require '../reporter'

# Simple reporter that outputs a plain list of titles and Ids.

class BasicReporter extends Reporter

  format: (callback) =>

    return callback() unless @data

    @output = "\n(#{@data.length}) discussions: \n\n"

    for i, index in @data
      @output += "##{i.id}: #{i.title}\n"

    callback()

module.exports = (options, callback) ->
  new BasicReporter(options, callback)

module.exports.description = "Simple id/title plain text list"

