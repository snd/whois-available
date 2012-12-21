net = require 'net'

module.exports =
    tcpRequest: (port, hostname, request, cb) ->

        socket = net.createConnection port, hostname
        socket.setEncoding 'utf8'
        socket.setTimeout 5000

        socket.on 'connect', -> socket.write request

        response = ''

        calledBack = false

        socket.on 'data', (data) -> response += data

        socket.on 'error', (error) ->
            cb error unless calledBack
            calledBack = true

        socket.on 'timeout', ->
            socket.end()
            cb new Error "request to #{hostname}:#{port} timed out" unless calledBack
            calledBack = true

        socket.on 'close', (hadError) ->
            cb null, response unless calledBack
            calledBack = true

    whoisRequest: (whoisServer, command, cb) ->
        module.exports.tcpRequest 43, whoisServer, "#{command}\r\n", cb
