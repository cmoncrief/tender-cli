path     = require 'path'
moment   = require 'moment'
csv      = require 'csv'
Reporter = require '../../reporter'

# Outputs a CSV file with all fields returned by the Tender API.

class CSVFullReporter extends Reporter

  map: (callback) =>
    @data = []
    header = {}
    
    for i in @options.data
      created = moment i.created_at
      @data.push
        id                : i.id
        number            : i.number 
        title             : i.title
        author_name       : i.author_name
        author_email      : i.author_email
        state             : i.state
        age               : created.fromNow(true)
        public            : i.public.toString()
        hidden            : i.hidden.toString()
        unread            : i.unread.toString()
        unresponded       : i.unresponded.toString()
        comments_count    : i.comments_count.toString()
        watchers_count    : i.watchers_count.toString()
        last_user_id      : i.last_user_id.toString()
        last_updated_at   : i.last_updated_at
        last_via          : i.last_via
        last_author_email : i.last_author_email
        last_author_name  : i.last_author_name
        href              : i.href

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
  new CSVFullReporter(options, callback)

module.exports.description = "Exports csv file with detailed fields"

