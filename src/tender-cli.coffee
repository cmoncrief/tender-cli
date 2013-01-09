fs        = require 'fs'
path      = require 'path'
moment    = require 'moment'
tender    = require 'tender'
Table     = require 'cli-table'
csv       = require 'csv'
reporters = require './reporters'

# Main entry point class. This class handles reading configuration
# files, instantiating the Tender client and all CLI operations.

class TenderCLI

  constructor: (@program, @options) ->
    @initClient()

  # Initialize the client from either command line options or a
  # user configuration file if it exists.
  initClient: ->

    config = {}
    configPath = path.join process.env.HOME, '.tenderrc'
    if fs.existsSync configPath
      config = JSON.parse fs.readFileSync(configPath)

    @clientOpts = 
      username: @program.username || config.username
      password: @program.pass || config.password
      subdomain: @program.subdomain || config.subdomain
      token: @program.api || config.token

    @client = tender.createClient @clientOpts

  # Lists discussions and applies optional filters. Results are
  # output via a reporter class.
  list: ->

    if @options.reporters
      return @listReporters "list"

    options = {}
    options.state = @options.state if @options.state
    options.category = @options.category if @options.category
    options.pattern = @options.title if @options.title
    options.queue = @options.queue if @options.queue
    options.max = @options.max if @options.max

    @client.getDiscussions options, (err, results) =>
      if err then return console.log(err)
      @report results, "list"

  # Show detailed view of a single discussion. Results are
  # output by a reporter class.
  show: (id) ->

    if @options.reporters
      return @listReporters "show"

    @client.showDiscussion {id : id}, (err, result) =>
      if err then return console.log(err)
      @report result, "show"

  # Output results via the chosen or defaulted reporter.
  report: (data, type) ->

    cmdReporters = reporters[type]

    reporter = cmdReporters[@options.reporter] || cmdReporters.default
    reporter data: data, cmdOptions: @options

  # Outputs a basic list of all available reporters that can be
  # used with the list command.
  listReporters: (type) ->

    cmdReporters = reporters[type]

    console.log ""

    for key of cmdReporters when key isnt 'default'
      console.log "  #{key} - #{cmdReporters[key].description}"
    
    console.log ""

tenderCLI = (program, options) ->
  new TenderCLI(program, options)

module.exports = tenderCLI