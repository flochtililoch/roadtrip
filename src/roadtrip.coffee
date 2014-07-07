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
      uri = "#{base_url}/beacons"

      console.log "## TRIED TO SYNC BUT OFFLINE ##" unless @online
      if @online
        @peripherals.pop (complete) ->
          (err, data) ->
            if err?
              console.log "## SYNC ERR ##", err
            if not err? and data?
              console.log "## SYNC ##", data
              {timestamp, peripheral, location} = data
              delete peripheral._id
              delete location._id
              json = {timestamp, peripheral, location}
              post {json, timeout, uri}, complete

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
    now = new Date()
    console.log "## NEW PERIPHERAL DISCOVERED AT #{now}##"
    console.log peripheral
    console.log "------------"
    @peripherals.push
      timestamp: now.getTime()
      peripheral: peripheral
      location: @locationScanner.currentLocation


module.exports = Roadtrip
