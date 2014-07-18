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

  push: (entry) ->
    @db.insert entry

  pop: (done) ->
    db = @db
    db.loadDatabase ->
      db.findOne {}, (err, item) ->
        complete = (err) => db.remove _id: item._id unless err?
        done(complete)(err, item)

  all: ->
    @db.getAllData()


module.exports = Datastore
