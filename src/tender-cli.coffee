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

  # Create a new discussion. Prints a basic success message.
  create: ->

    options =
      authorEmail: @options.email
      authorName: @options.name
      public: if @options.private then false else true
      category: @options.category
      title: @options.title
      body: @options.body

    @client.createDiscussion options, (err, result) =>
      if err then return console.log(err)
      console.log "Discussion ##{result.id} created in #{@options.category}."

  # Replies to an existing discussion and prints a basic success message.
  reply: (id) ->

    options =
      id: id
      authorEmail: @options.email
      authorName: @options.name
      internal: @options.internal
      body: @options.body

    @client.replyDiscussion options, (err, result) ->
      if err then return console.log(err)
      console.log "Discussion ##{id} replied to."

  # Resolves the discussion and prints a basic success message.
  resolve: (id) ->

    @client.resolveDiscussion {id: id}, (err, result) =>
      if err then return console.log(err)
      console.log "Discussion ##{id} resolved."

  # Reopens the discussion and prints a basic success message.
  reopen: (id) ->

    @client.reopenDiscussion {id: id}, (err, result) =>
      if err then return console.log(err)
      console.log "Discussion ##{id} reopened."

  # Acknowledges the discussion and prints a basic success message.
  ack: (id) ->

    @client.acknowledgeDiscussion {id: id}, (err, result) =>
      if err then return console.log(err)
      console.log "Discussion ##{id} acknowledged."

  # Adds the discssion to a queue and prints a basic success message.
  queue: (id) ->

    @client.queueDiscussion {id: id, queue: @options.queue}, (err, result) =>
      if err then return console.log(err)
      console.log "Discussion ##{id} added to the #{@options.queue} queue."

  # Removes the discussion from a queue and prints a basic success message.
  unqueue: (id) ->

    @client.unqueueDiscussion {id: id, queue: @options.queue}, (err, result) =>
      if err then return console.log(err)
      console.log "Discussion ##{id} removed from the #{@options.queue} queue."

  # Changes the discssusion's category and prints a basic success message.
  categorize: (id) ->

    @client.categorizeDiscussion {id: id, category: @options.category}, (err, result) =>
      if err then return console.log(err)
      console.log "Discussion ##{id} moved to the #{@options.category} category."

  # Deletes the discussion and prints a basic success message.
  remove: (id) ->

    @client.deleteDiscussion {id: id}, (err, result) =>
      if err then return console.log(err)
      console.log "Discussion ##{id} deleted."

  # Restores the discussion and prints a basic success message.
  restore: (id) ->

    @client.restoreDiscussion {id: id}, (err, result) =>
      if err then return console.log(err)
      console.log "Discussion ##{id} restored."

  # Toggle the discussion's private status and print a basic success message.
  toggle: (id) ->

    @client.toggleDiscussion {id: id}, (err, result) =>
      if err then return console.log(err)
      console.log "Discussion ##{id} toggled."

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