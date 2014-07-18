config = require '../config.json'
Roadtrip = require './roadtrip'

options =
  start: 'Start listening to surrounding radio environement'
  sync: 'Synchronize data with remote server'

args = process.argv.slice(2)
action = args[0]

unless options[action]
  console.log "Options:"
  console.log "  #{action}: #{description}" for action, description of options
  return

console.log "Starting task: #{options[action]}"
roadtrip = new Roadtrip
roadtrip[action]()
