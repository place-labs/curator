require "http/server"
require "json"
require "../event"
require "../relay/relay"

# TODO bulk import
# TODO Relay
# TODO PING PONG? https://github.com/alternatelabs/bifrost/blob/master/src/bifrost.cr#L80
module Curator
  class Controller
    getter :config, :port, :relay
    @port : Int32

    def initialize(@config : YAML::Any, @relay : Curator::Relay)
      @port = case config.dig?("port")
              when nil
                3000
              else
                config.dig("port").as_i
              end
    end

    def start
      server = HTTP::Server.new([ws_handler])
      address = server.bind_tcp(port)
      puts "Listening on ws://#{address}"
      server.listen
    end

    def ws_handler
      HTTP::WebSocketHandler.new do |socket, context|
        if authenticated?(context)
          socket.on_message do |message|
            begin
              relay(event(message))
            rescue e
            end
          end
        end
      end
    end

    private def relay(event : Curator::Event)
      relay.call(event)
    end

    private def event(data)
      Curator::Event.from_json(data)
    end

    private def authenticated?(http_context)
      key = http_context.request.headers["x-api-key"]?

      return false if key.nil?

      key == config["api_key"]
    end
  end
end
