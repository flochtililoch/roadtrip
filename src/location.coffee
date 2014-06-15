class Location

  constructor: ({timestamp, latitude, longitude, altitude, speed}) ->
    @timestamp = timestamp
    @latitude  = latitude
    @longitude = longitude
    @altitude  = altitude
    @speed     = speed

  isSameAs: (location) ->
    return false unless location instanceof Location

    round = (x) -> Math.ceil(x * 100000) / 100000
    sameLatitude = round(location.latitude) is round(@latitude)
    sameLongitude = round(location.longitude) is round(@longitude)
    sameAltitude = Math.ceil(location.altitude) is Math.ceil(@altitude)

    sameLatitude and sameLongitude and sameAltitude


module.exports = Location
