moment   = require 'moment'
Reporter = require '../../reporter'

# Outputs a basic vertical list of discussions in plain text, with 
# key fields.

class ListReporter extends Reporter

  map: (callback) =>
    @data = []
    
    for i in @options.data
      created = moment i.created_at
      @data.push
        id          : i.id
        title       : i.title
        author_name : i.author_name
        state       : i.state
        age         : created.fromNow(true)

    callback()

  format: (callback) =>

    return callback() unless @data

    @output = "\nDisplaying (#{@data.length}) discussions: \n"

    for i in @data
      @output += """

           Discussion ##{i.id}
           =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
           Title  : #{i.title}
           State  : #{i.state}
           Author : #{i.author_name}
           Age    : #{i.age}

      """

    callback()

module.exports = (options, callback) ->
  new ListReporter(options, callback)

module.exports.description = "Verbose vertical list"