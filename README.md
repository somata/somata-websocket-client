# somata-websocket-client

Client for use with [somata-websocket-server](https://github.com/somata/somata-websocket-server). Remote calls and subscriptions are returned as [Kefir](https://github.com/rpominov/kefir) streams.

## Installation

```
npm install somata-websocket-client
```

## Usage

Create a client by providing an address to connect to. Use `client.connected$` to wait until the connection is established.

```coffee
somata = require('somata-websocket-client')
client = somata('ws://192.168.0.115:5555')

client.connected$.onValue ->
    client.remote('hello', 'sayHello').onValue (response) ->
        console.log response

    client.subscribe('announcer', 'announce').onValue (announcement) ->
        console.log announcement
```
