Promise = require 'bluebird'

whois = require '../src/whois-available'

getServer = Promise.promisify(whois.getServer)
getAllTlds = Promise.promisify(whois.getAllTlds)

# generates server.coffee
getAllTlds().then (tlds) ->
  console.log 'module.exports ='
  Promise.all(tlds).each (tld) ->
    getServer(tld)
      .error (err) ->
        console.log 'error', err
      .then (server) ->
        if server?
          console.log "  '#{tld}': '#{server}'"
        Promise.delay(50)
