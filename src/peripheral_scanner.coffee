{EventEmitter} = require 'events'
noble          = require 'noble'
Peripheral     = require './peripheral'

class PeripheralScanner extends EventEmitter

  constructor: ->
    noble.on 'discover', @peripheralDiscovered
    noble.startScanning()

  peripheralDiscovered: ({advertisement, uuid}) =>
    peripheral = new Peripheral
      name: advertisement?.localName
      mac:  uuid.replace /(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})/, "$1:$2:$3:$4:$5:$6"
    @emit 'newperipheral', peripheral


module.exports = PeripheralScanner
