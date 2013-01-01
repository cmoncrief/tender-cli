program   = require 'commander'
tenderCLI = require './tender-cli'

# Main CLI entry point. CLI arguments are parsed here and passed off 
# to the main tenderCLI module for processing.

module.exports.run = () ->

  program
    .version('0.1.0')
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
    .option('-o, --output <name>', 'specify file name for csv reporters ')
    .option('--reporters', 'List available reporters')

    .action (args) ->
      tenderCLI(program, args).list()

  program.parse process.argv