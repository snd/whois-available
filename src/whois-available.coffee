net = require 'net'
http = require 'http'
punycode = require 'punycode'

whoisServersGenerated = require './data/whois-servers-generated'
whoisServersPatches = require './data/whois-servers-patches'
requests = require './data/requests'
substringsAvailable = require './data/substrings-available'
substringsNotAvailable = require './data/substrings-not-available'

module.exports = (domain, cb) ->
  if domain is ''
    process.nextTick ->
      cb new Error 'domain must not be empty'
    return

  domainPunycode = punycode.toASCII domain

  domainParts = domainPunycode.split '.'

  tld = domainParts[domainParts.length-1]

  server = whoisServers[tld]
  unless server?
    process.nextTick ->
      # TODO finish this message
      cb new Error "no known whois server for tld #{tld}. read xxx on how to add one"
    return

  domainToRequest = requests[server] or (x) -> x

  request = domainToRequest domainPunycode

  module.exports.whoisRequest server, request, (err, response) ->
    if err?
      cb err
      return

    availableBecauseResponseContained = containsAny substringsAvailable, response
    if availableBecauseResponseContained?
      # butNotAvailableBecauseResponseContained = null
      butNotAvailableBecauseResponseContained = containsAny substringsNotAvailable, response

    cb null,
      isAvailable: availableBecauseResponseContained? and (not butNotAvailableBecauseResponseContained?)
      domain: domain
      punycode: domainPunycode
      tld: tld
      response: response
      availableBecauseResponseContained: availableBecauseResponseContained
      butNotAvailableBecauseResponseContained: butNotAvailableBecauseResponseContained
      server: server
      request: request

whoisServers = {}
Object.keys(whoisServersGenerated).forEach (tld) ->
  # manually disabled ?
  unless whoisServersPatches[tld] is null
    whoisServers[tld] = whoisServersGenerated[tld]
Object.keys(whoisServersPatches).forEach (tld) ->
  unless whoisServersPatches[tld] is null
    # update or addition
    whoisServers[tld] = whoisServersPatches[tld]

whoisAvailable.tlds = Object.keys(whoisServers)

whoisAvailable.tcpRequest = (port, hostname, request, cb) ->
  socket = net.createConnection port, hostname
  socket.setEncoding 'utf8'
  timeoutSeconds = 20
  socket.setTimeout timeoutSeconds * 1000

  socket.on 'connect', -> socket.write request

  response = ''
  cbCalled = false

  socket.on 'data', (data) -> response += data

  socket.on 'error', (error) ->
    unless cbCalled
      cb error
    cbCalled = true

  socket.on 'timeout', ->
    socket.end()
    unless cbCalled
      cb new Error "request to #{hostname}:#{port} timed out"
    cbCalled = true

  socket.on 'close', (hadError) ->
    unless cbCalled
      cb null, response
    cbCalled = true

whoisRequest = (whoisServer, request, cb) ->
  tcpRequest 43, whoisServer, "#{request}\r\n", cb

httpGet = (url, cb) ->
  http.get(url, (res) ->
    body = ''
    res.on 'data', (data) ->
      body += data
    res.on 'end', ->
      cb null, res, body
  ).on 'error', (err) ->
    cb err

getAllTlds = (cb) ->
  httpGet 'http://data.iana.org/TLD/tlds-alpha-by-domain.txt', (err, res, body) ->
    if err?
      cb err
      return
    unless res.statusCode is 200
      cb new Error "response status code wasn't 200 but #{res.statusCode} instead"
      return
    domains = body
      .split('\n')
      .map (x) -> x.trim().toLowerCase()
      # doesn't begin with '#'
      .filter (x) -> 0 isnt x.indexOf('#')
      # not blank
      .filter (x) -> x isnt ''
    cb null, domains

domainToTld = (domain) ->
  domainPunycode = punycode.toASCII domain
  domainParts = domainPunycode.split '.'
  return domainParts[domainParts.length-1]

# get domain of the whois server responsible for the tld of a domain
getServer = (domain, cb) ->
  whoisRequest 'whois.iana.org', domainToTld(domain), (err, result) ->
    if err?
      cb err
      return
    match = /whois:\s+(\S+)/.exec result
    unless match?[1]?
      cb()
      return
    cb null, match[1]

containsAny = (array, string) ->
  index = -1
  length = array.length
  # TODO this is probably really really inefficient
  while ++index < length
    if -1 isnt string.indexOf array[index]
      return array[index]
  return

isSupported = (domain) ->
  whoisServers[domainToTld(domain)]?

module.exports.tcpRequest = tcpRequest
module.exports.tcpRequest = tcpRequest
module.exports.whois = whois
module.exports.domainToTld = domainToTld
module.exports.getServer = getServer
module.exports.getAllTlds = getAllTlds
module.exports.isSupported = isSupported
module.exports.whoisServers = whoisServers
