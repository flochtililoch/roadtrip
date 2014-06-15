{EventEmitter} = require 'events'
nedb = require 'nedb'

class Datastore extends EventEmitter

  filename: 'datastore'

  path: "#{__dirname}/.."

  load: ->
    @db = new nedb
      filename: "#{@path}/#{@filename}.db"
      autoload: true
      onload: => @emit 'ready'

  add: (entry) ->
    @db.insert entry

  all: ->
    @db.getAllData()


module.exports = Datastore
