Reporter = require '../../reporter'
moment   = require 'moment'

# Simple reporter that outputs a plain list of titles and Ids.

class BasicReporter extends Reporter

  format: (callback) =>

    return callback() unless @data

    tags = ""
    tags += if @data.unread then "[unacknowledged] " else "[acknowledged] "
    tags += if @data.responded then "[unresponded] " else "[responded] " 
    tags += if @data.public then "[public] " else "[private] "
    tags += "[hidden] " if @data.hidden
    tags += "[via #{@data.via}] "

    df = 'M/D/YYYY H:MM a'

    @output = """

           Discussion ##{@data.id}
           =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
           Title    : #{@data.title}
           Author   : #{@data.author_name} (#{@data.author_email})
           Created  : #{moment(@data.created_at).format(df)}
           URL      : #{@data.html_href}
           State    : #{@data.state}
           Comments : #{@data.comments_count}
           Details  : #{tags}

           Description:
           
           #{@data.comments[0].body}    

      """
      
    callback()

module.exports = (options, callback) ->
  new BasicReporter(options, callback)

module.exports.description = "Basic headers and the first comment"

