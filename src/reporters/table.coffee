moment   = require 'moment'
Table    = require('cli-table')
Reporter = require '../reporter'

# Outputs a table of discussions with key fields only. 

class TableReporter extends Reporter

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

    table = new Table
      head: ['Id', 'Title', 'Author', 'State', 'Age']
      colWidths: [10, 45, 16, 10, 10]

    for i in @data
      table.push [i.id, i.title, i.author_name, i.state, i.age]

    @output = table.toString()
    callback()

module.exports = (options, callback) ->
  new TableReporter(options, callback)

module.exports.description = "Summary fields in table format"