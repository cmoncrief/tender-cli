program   = require 'commander'
tenderCLI = require './tender-cli'

# Main CLI entry point. CLI arguments are parsed here and passed off 
# to the main tenderCLI module for processing.

module.exports.run = () ->

  program
    .version('0.2.0')
    .option('-u, --username <name>', 'set Tender username')
    .option('-p, --pass <password>', 'set Tender password')
    .option('-a, --api <token>', 'set Tender API token')
    .option('-d, --subdomain <subdomain>', 'set Tender subdomain name')

  program
    .command('list')
    .description('List discussions with optional filters')
    .option('-q, --queue <name>', 'filter by queue')
    .option('-s, --state <name>', 'filter by state')
    .option('-c, --category <name>', 'filter by category')
    .option('-t, --title <pattern>', 'filter by title pattern')
    .option('-m, --max <number>', 'max records to retrieve (defaults to 1000)')
    .option('-r, --reporter <name>', 'Specify the reporter to use')
    .option('-o, --output <name>', 'specify file name for file reporters ')
    .option('--reporters', 'List available reporters')
    .action (args) ->
      tenderCLI(program, args).list()

  program
    .command('show [id]')
    .description('Show single discussion with comments')
    .option('-r, --reporter <name>', 'Specify the reporter to use')
    .option('--reporters', 'List available reporters')
    .action (id, args) ->
      tenderCLI(program, args).show(id)

  program
    .command('create')
    .description('Create a new discussion')
    .option('-t, --title <name>', 'title for the new discussion [required]')
    .option('-c, --category <name>', 'category to post under [required]')
    .option('-b, --body <text>', 'the body of the new discussion [required]')
    .option('--private', 'set discussion to private')
    .option('-n, --name <name>', 'Name to create discussion under')
    .option('-e, --email <email>', 'Email to create discussion under')
    .action (args) ->
      tenderCLI(program, args).create()

  program
    .command('reply [id]')
    .description('Reply to an existing discussion')
    .option('-b, --body <text>', 'the body of the reply [required]')
    .option('--internal', 'set reply to internal')
    .option('-n, --name <name>', 'Name to reply from')
    .option('-e, --email <email>', 'Email to reply from')
    .action (id, args) ->
      tenderCLI(program, args).reply(id)

  program
    .command('ack [id]')
    .description('Acknowledge a discussion')
    .action (id, args) ->
      tenderCLI(program, args).ack(id)

  program
    .command('resolve [id]')
    .description('Close a discussion')
    .action (id, args) ->
      tenderCLI(program, args).resolve(id)

  program
    .command('reopen [id]')
    .description('Reopen a discussion')
    .action (id, args) ->
      tenderCLI(program, args).reopen(id)

  program
    .command('queue [id]')
    .description('Assign a discussion to a queue')
    .option('-q, --queue <name>', 'queue to add to [required]')
    .action (id, args) ->
      tenderCLI(program, args).queue(id)

  program
    .command('unqueue [id]')
    .description('Remove a discussion from a queue')
    .option('-q, --queue <name>', 'queue to remove from [required]')
    .action (id, args) ->
      tenderCLI(program, args).unqueue(id)

  program
    .command('categorize [id]')
    .description('Change a discussion\'s category')
    .option('-c, --category <name>', 'category to change to [required]')
    .action (id, args) ->
      tenderCLI(program, args).categorize(id)

  program
    .command('delete [id]')
    .description('Delete a discussion')
    .action (id, args) ->
      tenderCLI(program, args).remove(id)

  program
    .command('restore [id]')
    .description('Restore a deleted discussion')
    .action (id, args) ->
      tenderCLI(program, args).restore(id)

  program
    .command('toggle [id]')
    .description('Toggle a discussion from public to private')
    .action (id, args) ->
      tenderCLI(program, args).restore(id)

  program.parse process.argv