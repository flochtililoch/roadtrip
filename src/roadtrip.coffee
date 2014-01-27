LocationScanner   = require './location_scanner'
PeripheralScanner = require './peripheral_scanner'
Locations         = require './locations'
Peripherals       = require './peripherals'
Datastore         = require 'nedb'

class Roadtrip

  constructor: ->
    @locationScanner = new LocationScanner
    @peripheralScanner = new PeripheralScanner

    @locations = new Locations
    @peripherals = new Peripherals

    @locationScanner.on 'newlocation', @addLocation
    @peripheralScanner.on 'newperipheral', @addPeripheral

  addLocation: (location) =>
    @locations.add location

  addPeripheral: (peripheral) =>
    @peripherals.add
      peripheral: peripheral
      location: @locationScanner.currentLocation


module.exports = Roadtrip
