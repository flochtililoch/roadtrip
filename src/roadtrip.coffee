LocationScanner   = require './location_scanner'
PeripheralScanner = require './peripheral_scanner'
Locations         = require './locations'
Peripherals       = require './peripherals'
Datastore         = require 'nedb'

class Roadtrip

  constructor: ->
    @locations = new Locations
    @peripherals = new Peripherals

    @locationScanner = new LocationScanner
    @locationScanner.on 'newlocation', @addLocation
    @locationScanner.once 'newlocation', @initPeripheralScanner

  initPeripheralScanner: =>
    @peripheralScanner = new PeripheralScanner
    @peripheralScanner.on 'newperipheral', @addPeripheral

  addLocation: (location) =>
    @locations.add location

  addPeripheral: (peripheral) =>
    @peripherals.add
      peripheral: peripheral
      location: @locationScanner.currentLocation


module.exports = Roadtrip
