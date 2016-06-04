Kefir = require 'kefir'
KefirBus = require 'kefir-bus'

randomString = (len=8) ->
    s = ''
    while s.length < len
        s += Math.random().toString(36).slice(2, len - s.length+2)
    return s

module.exports = (address) ->
    connected$ = KefirBus()
    connected$.onValue -> alert 'connected'
    message$ = KefirBus()

    ws = null

    connect = ->
        ws = new WebSocket address
        ws.onopen = -> connected$.emit true

        ws.onclose = ->
            alert 'closed'
            connect()

        ws.onmessage = ({data}) ->
            message$.emit JSON.parse data

    remote = (service, method, args...) ->
        id = randomString()
        data = JSON.stringify {kind: 'remote', service, method, args, id}
        ws.send data

        message$
            .filter (message) -> message.kind == 'response' and message.id == id
            .map (message) -> message.response

    subscribe = (service, type) ->
        data = JSON.stringify {kind: 'subscribe', service, type}
        ws.send data

        message$
            .filter (message) -> message.kind == 'event' and message.type == type
            .map (message) -> message.event

    connect()

    return {
        remote
        subscribe
        connected$
        message$
    }

