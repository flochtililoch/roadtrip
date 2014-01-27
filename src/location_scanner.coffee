{EventEmitter} = require 'events'
Bancroft       = require 'bancroft'
Location       = require './location'

class LocationScanner extends EventEmitter

  constructor: ->
    (new Bancroft).on 'location', @locationAquired

  locationAquired: (data) =>
    location = new Location data
    unless location.isSameAs @currentLocation
      @currentLocation = location
      @lastLocationUpdate = new Date
      @emit 'newlocation', location

  idleSince: ->
    new Date().getTime - @lastLocationUpdate?.getTime()


module.exports = LocationScanner
