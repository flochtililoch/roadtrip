nedb = require 'nedb'

class Datastore

  filename: 'datastore'

  path: "#{__dirname}/.."

  constructor: ->
    @db = new nedb
      filename: "#{@path}/#{@filename}.db"
      autoload: true

  add: (entry) ->
    @db.insert entry


module.exports = Datastore
