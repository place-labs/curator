[![Build Status](https://travis-ci.com/PlaceOS/curator.svg?branch=master)](https://travis-ci.com/PlaceOS/curator)

# Curator

Server that accepts `Event` via WebSocket or HTTP POST request. Filters them based on defined rules. Forwards thems to other nodes.

## Available endpoints:

Upon start, server exposes two endpoints:

1. `/ingest` Websocket endpoint which accepts `Event` in a json format.
2. `/ingest` HTTP POST endpoint which accepts `Event` in bulk, where list of events are specified in ndjson format.

## Starting server as crystal script

```bash
API_KEY=password CURATOR_ID=cur-45678 CURATOR_PEPPER=secret FORWARDS="ws://127.0.0.1:4444|secret_api_key" crystal run src/curator.cr
```

## Configuration

### Available Environment variables:
* ENV["PORT"]
  * Port on which the WebSocket and HTTP POST endpoints are available
  * **Optional** - Default value: 3000
* ENV["API_KEY"]
  * API Key that needs to be passed as `x-api-key` header to communicate with the Curator endpoints.
  * **Required**
* ENV["CURATOR_ID"]
  * Unique ID that identifies a running curator instance. Appended to `Event.cur` before forwarding.
  * **Required**
* ENV["CURATOR_PEPPER"]
  * PEPPER string that is used to hash the `Event.ref` before forwarding.
  * **Required**
* ENV["FORWARDS"]
  * List of forward nodes that will receive the event via WebSocket after they have been filtered by the curator.
  * Format: `"URL_1|KEY_1 URL_2|KEY_2"`
  * e.g. `"ws://127.0.0.1:2000|SECRET1 ws://127.0.0.1:3000|SECRET2"`
  * **Required**
* ENV["BUFFER_SIZE"]
  * Number of `Event` that are buffered per forward. If a forward defined in the configuration isnt available, incoming event is stored until curator can reconnect. Upon connection, buffered events are offloaded to the forward. Buffer is implemented as `RingBuffer` where recent events, push the old events out when buffer capacity is reached.
  * **Optional** - Default value: 100,000

### Event filtering rules:
Curator accepts rules in a yml format. Rules are defined in `config/rules.yml` for all `Event` attributes except `Event.ref`.

`Event.ref` rules are defined in `config/ref_rules.yml`



`rules.yml` example:

```yml
-
  attribute: "org"
  operation: "exclude"
  values:
    - fb
-
  attribute: "org"
  operation: "include"
  values:
    - microsoft
    - google
-
  attribute: "uts"
  operation: "greater_than_equal"
  values:
    - 1580276617006
-
  attribute: "uts"
  operation: "less_than_equal"
  values:
    - 1880276617000
```

`ref_rules.yml` example:

```yml
-
  attribute: "ref"
  operation: "exclude"
  values:
    - blank
    - user@example.com
```

#### Allowed Operators for Rules:
Available operators are `Event` attribute dependent.

* If `Event` attribute: `uts`
  * available operators: [greater_than_equal, less_than_equal]
* For rest of attributes
  * available operators:  [include, exclude]

#### Allowed values for Rules:

* For `greater_than_equal` and `less_than_equal` operators
  * values is an array with single `unix timestamp` value as a `Int64`.
  * e.g [1580276617006]
* For `include` and `exclude`
  * values is an array with as many `string` values as needed.
    * e.g ["test-123", "mod-555"]
  * To match against empty values, `blank` string value can be provided.
    * e.g ["test-123", "blank", "mod-555"]


## Development

To run specs `crystal spec`

## Contributing

1. Fork it (<https://github.com/PlaceOS/curator/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request