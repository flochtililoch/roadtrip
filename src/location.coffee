log = require './log'
geolib = require 'geolib'

class Location

  constructor: ({timestamp, latitude, longitude, altitude, speed}) ->
    @timestamp = timestamp
    @latitude  = latitude
    @longitude = longitude
    @altitude  = altitude
    @speed     = speed

  isSameAs: (location) ->
    return false unless location instanceof Location

    try
      distance = geolib.getDistance location, this
      distance < 10 and Math.abs(location.altitude - @altitude) < 2
    catch error
      log 'Error getting distance between previous and new location:'
      log error
      false


module.exports = Location
