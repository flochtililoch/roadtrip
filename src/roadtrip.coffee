LocationScanner   = require './location_scanner'
PeripheralScanner = require './peripheral_scanner'
Locations         = require './locations'
Peripherals       = require './peripherals'
photon            = require 'freedompop-photon-cli/lib/photon'

class Roadtrip

  constructor: ->
    @locations = new Locations
    @peripherals = new Peripherals

  start: ->
    @locations.once 'ready', =>
      @locationScanner = new LocationScanner
      @locationScanner.on 'newlocation', @addLocation
      @locationScanner.once 'newlocation', @initPeripheralScanner
    @locations.load()

  sync: ->
    @peripherals.once 'ready', =>
      console.log @peripherals.all()
    @peripherals.load()

  initPeripheralScanner: =>
    @peripherals.once 'ready', =>
      @peripheralScanner = new PeripheralScanner
      @peripheralScanner.on 'newperipheral', @addPeripheral
    @peripherals.load()

  addLocation: (location) =>
    @locations.add location

  addPeripheral: (peripheral) =>
    @peripherals.add
      peripheral: peripheral
      location: @locationScanner.currentLocation


module.exports = Roadtrip
