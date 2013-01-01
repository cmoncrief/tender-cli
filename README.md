# Tender CLI

A command line tool for interacting with ENTP's [Tender API](https://help.tenderapp.com/kb/api).

## Installation

Install with npm:

    $ npm install -g tender-cli

If you don't already have Node.js installed, [download and install it first](http://nodejs.org/).

## Usage

    Usage: tender [options] [command]

    Commands:

      list [options]         List discussions with optional filters

    Options:

      -h, --help                   output usage information
      -V, --version                output the version number
      -u, --username <name>        set Tender username
      -p, --pass <password>        set Tender password
      -a, --api <token>            set Tender API token
      -d, --subdomain <subdomain>  set Tender subdomain name

## Basic example

    $ tender list --state pending

    ┌──────────┬─────────────────────────────────────────────┬────────────────┬──────────┬──────────┐
    │ Id       │ Title                                       │ Author         │ State    │ Age      │
    ├──────────┼─────────────────────────────────────────────┼────────────────┼──────────┼──────────┤
    │ 1234567  │ Login issue                                 │ John Smith     │ pending  │ 1 hour   │
    ├──────────┼─────────────────────────────────────────────┼────────────────┼──────────┼──────────┤
    │ 1234567  │ All of my permissions are gone!             │ Jane Smith     │ pending  │ 2 days   │
    └──────────┴─────────────────────────────────────────────┴────────────────┴──────────┴──────────┘

## Authentication

Authentication via username/password or API token are both supported. These can either be specified on the command line itself or stored in a `.tenderrc` file located in your home directory. The file should follow the below format, though note that only username/password or token are required, not both. 

    {
      "subdomain": "your-sub-domain",
      "username": "someone@somewhere.com",
      "password": "supersecret",
      "token": "your-api-token",
    }

#### Example of command line auth:

    $ tender list --subdomain your-sub-domain --token your-api-token

## Listing discussions

    Usage: list [options]

    Options:

      -h, --help             output usage information
      -q, --queue <name>     filter by queue
      -s, --state <name>     filter by state
      -c, --category <name>  filter by category
      -t, --title <pattern>  filter by title pattern
      -m, --max <number>     max records to retrieve (defaults to 1000)
      -r, --reporter <name>  Specify the reporter to use
      -o, --output <name>    specify file name for csv reporters 
      --reporters            List available reporters

Several filters and reporters are available for selecting discussions. Below are examples of some common filtering actions.

#### List all pending discussions

    $ tender list -s pending

#### List all open discussions in "Test" queue

    $ tender list -s open -q test

#### List discussions in the "Bar" queue with "Foo" in the title

    $ tender list -t foo -q bar

#### List all assigned discussions in the "Problems" category

    $ tender list -c problems -s assigned

## Discussion reporters

### Table

This reporter displays discussions in a table format with a few key columns. This is the default reporter.

    ┌──────────┬─────────────────────────────────────────────┬────────────────┬──────────┬──────────┐
    │ Id       │ Title                                       │ Author         │ State    │ Age      │
    ├──────────┼─────────────────────────────────────────────┼────────────────┼──────────┼──────────┤
    │ 1234567  │ Login issue                                 │ John Smith     │ pending  │ 1 hour   │
    ├──────────┼─────────────────────────────────────────────┼────────────────┼──────────┼──────────┤
    │ 1234567  │ All of my permissions are gone!             │ Jane Smith     │ pending  │ 2 days   │
    └──────────┴─────────────────────────────────────────────┴────────────────┴──────────┴──────────┘

### Basic

This reporter displays a very simple list of discussion ids and titles.

    (2) discussions: 

    #1234567: Login issue
    #1234567: All of my permissions are gone!

### List

This reporter outputs a vertical list of discussions with a few key fields.

    Displaying (2) discussions: 

    Discussion #1234567
    =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    Title  : Login issue
    State  : pending
    Author : John Smith
    Age    : 1 hour

    Discussion #1234567
    =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    Title  : All of my permissions are gone!
    State  : pending
    Author : Jane Smith
    Age    : 2 days 

### JSON

This reporter will output a JSON file with all available columns. The file name defaults
to `tender_output.json`in the current working directory, but can be specified with the
`--output` command line option.

### CSV

This reporter will output a CSV file with the same columns as the default Table reporter.
The file name defaults to `tender_output.csv` in the current working directory, but can be specified 
with the `--output` command line options.

### CSVFull

Same as above, but will output all available columns.

## Running the tests

To run the test suite, invoke the following commands in the repository:

    $ npm install
    $ npm test
    
Please note that the majority of the tests rely on a live Tender API account in order to execute. 
To set up the test data for your account, create a `.tenderrc` configuration file as shown above and add a
`testData` object with the following keys:

* `queue` - The name of a queue in your account.
* `category` - The name of a category in your account.
* `user` - The full name of a user belonging to your Tender account.
* `userId` - The id of a user belonging to your Tender account.
* `discussionId` - The id of any discussion belonging to your account
* `pattern` - A regexp pattern that will match the title of at least one Open discussion on your account.

#### Example .tenderrc for testing:

    {
      "subdomain": "your-sub-domain",
      "token": "your-api-token",
      "testData" : {
        "queue" : "Test queue",
        "category" : "Test category",
        "user" : "Charles Moncrief",
        "userId" : "12345",
        "discussionId" : "12345",
        "pattern" : "xyz"
      }
    }

__All tests perform read operations only. No data will be modified.__


