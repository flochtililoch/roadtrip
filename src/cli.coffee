Roadtrip = require './roadtrip'

options =
  start: 'Start listening to surrounding radio environement'
  sync: 'Automatically upload data when internet connexion available'

args = process.argv.slice(2)
action = args[0]

unless options[action]
  console.log "Options:"
  console.log "  #{action}: #{description}" for action, description of options
  return

roadtrip = new Roadtrip
roadtrip[action]()
