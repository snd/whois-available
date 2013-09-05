punycode = require 'punycode'

common = require './common'

whoisServers = require './whois-servers'
whoisCommands = require './whois-commands'
availabilityChecks = require './availability-checks'

module.exports = (domain, cb) ->

    if domain is ''
        return process.nextTick -> cb new Error 'domain must not be empty'

    domainPunycode = punycode.toASCII domain

    domainParts = domainPunycode.split '.'

    tld = domainParts[domainParts.length-1]

    whoisServer = whoisServers[tld]
    unless whoisServer?
        return process.nextTick -> cb new Error "no whois server for tld #{tld}"

    availabilityCheck = availabilityChecks[whoisServer]
    unless availabilityCheck?
        return process.nextTick -> cb new Error "no check for availability for whois server #{whoisServer}"

    command = whoisCommands[whoisServer] || (x) -> x

    common.whoisRequest whoisServer, command(domainPunycode), (err, response) ->
        return cb err if err?

        isAvailable = -1 isnt response.indexOf availabilityCheck

        cb null, response, isAvailable
