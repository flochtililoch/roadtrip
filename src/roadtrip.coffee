config            = require '../config.json'
LocationScanner   = require './location_scanner'
PeripheralScanner = require './peripheral_scanner'
Locations         = require './locations'
Peripherals       = require './peripherals'
Photon            = require 'freedompop-photon-cli/lib/photon'
photonConfig      = require '../photon-config.json'
{post}            = require 'request'

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

  setOffline: ->
    @online = false

  setOnline: ->
    @online = true

  sync: ->
    @setOffline()

    photon = new Photon photonConfig.network.ip, photonConfig
    photon
      .on('error_communicating_with_photon', => @setOffline())
      .on('lost_configuration',              => @setOffline())
      .on('disconnected',                    => @setOffline())
      .on('connected',                       => @setOnline())
      .monitor()

    sync = =>
      {timeout, frequency, base_url} = config.sync
      uri = "#{base_url}/trips"

      if @online
        @peripherals.pop (complete) ->
          (err, data) ->
            if not err? and data?
              form = data: JSON.stringify data
              post {form, timeout, uri}, complete

      setTimeout sync, frequency

    @peripherals.once 'ready', sync

    @peripherals.load()

  initPeripheralScanner: =>
    @peripherals.once 'ready', =>
      @peripheralScanner = new PeripheralScanner
      @peripheralScanner.on 'newperipheral', @addPeripheral
    @peripherals.load()

  addLocation: (location) =>
    @locations.push location

  addPeripheral: (peripheral) =>
    @peripherals.push
      peripheral: peripheral
      location: @locationScanner.currentLocation


module.exports = Roadtrip
