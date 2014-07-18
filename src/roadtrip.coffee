config            = require '../config.json'
LocationScanner   = require './location_scanner'
PeripheralScanner = require './peripheral_scanner'
Locations         = require './locations'
Peripherals       = require './peripherals'
Photon            = require 'freedompop-photon-cli/lib/photon'
photonConfig      = require '../photon-config.json'
log               = require './log'
{post}            = require 'request'

class Roadtrip

  constructor: ->
    @locations = new Locations
    @peripherals = new Peripherals

  start: ->
    @locations.once 'ready', =>
      log 'Location scanner ready'
      @locationScanner = new LocationScanner
      @locationScanner.on 'newlocation', @addLocation
      @locationScanner.once 'newlocation', @initPeripheralScanner
    @locations.load()

  setOffline: ->
    @online = false

  setOnline: ->
    log "Link back up at #{new Date}", true
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

    {timeout, min_delay, max_delay, base_url} = config.sync
    delay = undefined

    resetDelay = -> delay = min_delay
    increaseDelay = -> delay = delay * 2

    resetDelay()

    uri = "#{base_url}/beacons"

    sync = =>
      @peripherals.once 'ready', =>
        unless @online
          increaseDelay()
          log "Offline. Will try again in #{delay / 1000} seconds."
        else
          resetDelay()
          @peripherals.pop (complete) ->
            log "Syncing. Next sync in #{delay / 1000} seconds."
            (err, data) ->
              if err?
                log 'Error while syncing:'
                log err
              if not err? and data?
                log 'Synced:'
                log data
                {timestamp, peripheral, location} = data
                delete peripheral._id
                delete location._id
                json = {timestamp, peripheral, location}
                post {json, timeout, uri}, complete

        setTimeout sync, delay

      @peripherals.load()

    sync()

  initPeripheralScanner: =>
    @peripherals.once 'ready', =>
      log 'Peripheral scanner ready'
      @peripheralScanner = new PeripheralScanner
      @peripheralScanner.on 'newperipheral', @addPeripheral
    @peripherals.load()

  addLocation: (location) =>
    log 'New location acquired:'
    log location
    @locations.push location

  addPeripheral: (peripheral) =>
    now = new Date()
    log 'New peripheral discovered:'
    log peripheral
    @peripherals.push
      timestamp: now.getTime()
      peripheral: peripheral
      location: @locationScanner.currentLocation


module.exports = Roadtrip
