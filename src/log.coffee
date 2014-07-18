config = require '../config.json'
logentries = require 'node-logentries'
util = require 'util'

logger = logentries.logger
  token: config.logentries.token

module.exports = (log, forceRemote = false) ->
  method = if typeof log is 'object' then 'debug' else 'info'
  console.log(log)
  logger[method](log) if config.logentries.enabled or forceRemote
