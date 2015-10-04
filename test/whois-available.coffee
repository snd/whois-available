_ = require 'lodash'
Promise = require 'bluebird'

whoisAvailable = require '../src/whois-available'

whoisAvailablePromise = Promise.promisify(whoisAvailable)
getServer = Promise.promisify(whoisAvailable.getServer)
getAllTlds = Promise.promisify(whoisAvailable.getAllTlds)

domainsNotAvailable = require '../src/data/domains-not-available'

module.exports =
  # 'consistency checks':

    # 'count of supported toplevel domains': (test) ->
    #   test.equal 170, availableDomainsKeys.length
    #   test.done()

    # 'tlds in tld-available-test-domain-mapping and tld-server-mapping match up': (test) ->
    #   # console.log _.difference(serversKeys, availableDomainsKeys)
    #   # console.log _.difference(availableDomainsKeys, serversKeys)
    #   test.deepEqual serversKeys, availableDomainsKeys
    #   test.done()

    # 'tlds in tld-unavailable-test-domain-mapping and tld-server-mapping match up': (test) ->
      # console.log _.difference(serversKeys, unavailableDomainsKeys)
      # console.log _.difference(unavailableDomainsKeys, serversKeys)
      # test.deepEqual serversKeys, unavailableDomainsKeys
      # test.done()

    # 'servers in tld-server-mapping and server-predicate-mapping match up': (test) ->
    #   console.log _.difference(serversValues, predicatesKeys)
    #   console.log _.difference(predicatesKeys, serversValues)
    #   test.deepEqual serversValues, predicatesKeys
    #   test.done()

    # 'available test domains end with correct tld': (test) ->
    #   _.each availableDomains, (domain, tld) ->
    #     # console.log
    #     #   domain: domain
    #     #   tld: tld
    #     test.ok _.endsWith domain, tld
    #   test.done()

    # 'unavailable test domains end with correct tld': (test) ->
    #   test.done()

    # 'there is a name server for every tld': (test) ->
    #   getAllTlds()
    #     .then (tlds) ->
    #       console.log tlds
    #       console.log tlds.length
    #     .finally ->
    #       test.done()

    # 'authoritative whois servers are up to date': (test) ->
    #   test.expect serversKeys.length
    #   iterator = (tld) ->
    #     getServer(tld).then (server) ->
    #       console.log
    #         tld: tld
    #         actual: server
    #         expected: servers[tld]
    #       test.equal servers[tld], server
    #       Promise.delay(100)
    #   Promise.all(serversKeys).each(iterator).finally ->
    #     console.log 'done'
    #     test.done()

  'available and not unavailable domains are correctly identified for each supported tld': (test) ->
    # test.expect whoisAvailable.tlds.length * 3
    iterator = (tld) ->
      availableDomain = '92705203b4c50' + '.' + tld
      notAvailableDomain = domainsNotAvailable[tld]
      console.log availableDomain
      whoisAvailablePromise(availableDomain)
        .then (result) ->
          unless result.isAvailable
            console.log result
          # TODO this should fail right here
          test.ok result.isAvailable
          test.ok 'string' is typeof result.response
          test.ok result.response.length > 0
          test.ok result.availableBecauseResponseContained?
          test.ok not result.notAvailableBecauseResponseContained?
        .error (err) ->
          console.error err
        .then ->
          unless notAvailableDomain?
            Promise.delay(10)
          else
            console.log notAvailableDomain
            whoisAvailablePromise(notAvailableDomain)
              .then (result) ->
                if result.isAvailable
                  console.log result
                test.ok not result.isAvailable
                test.ok 'string' is typeof result.response
                test.ok result.response.length > 0
              .error (err) ->
                console.error err
              .then ->
                Promise.delay(10)

    Promise.all(whoisAvailable.tlds).each(iterator).finally ->
      console.log 'done'
      test.done()

#   'unavailable domains are correctly identified for each supported tld': (test) ->

#   'readme example': (test) ->
#     test.done()
