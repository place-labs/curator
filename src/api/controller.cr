require "http/server"
require "json"
require "../event"
require "./helpers"
require "./http_handler"
require "../relay/relay"

module Curator
  module Api
    # API Controller
    # Responsible for accepting incoming `event` data.
    # Exposes two endpoints
    # 1. `/ingest` WebSocket, which accepts event in json format
    # 2. `/ingest` HTTP POST, which accepts events in ndjson format
    # Hands off the event to `Relay`
    class Controller
      include Curator::Api::Helpers
      getter :port, :relay, :auth
      @port : Int32
      @server : HTTP::Server?

      def initialize(@relay : Curator::Relay, @auth : Curator::Utils::Auth)
        @port = ENV.has_key?("PORT") ? ENV["PORT"].to_i : 3000
      end

      # Starts the HTTP::Server to serve incoming requests.
      def start
        @server = HTTP::Server.new([ws_handler, HttpHandler.new(relay: relay, auth: auth)])
        address = @server.not_nil!.bind_tcp(port)
        puts "Listening on ws://#{address}"
        puts "Listening on http://#{address}"
        @server.not_nil!.listen
      end

      def stop
        @server.not_nil!.close unless @server.not_nil!.closed?
      end

      private def ws_handler
        HTTP::WebSocketHandler.new do |socket, context|
          if auth.valid?(context)
            case request_path(context)
            when "/ingest"
              socket.on_message do |message|
                begin
                  relay.call(to_event(message))
                rescue e
                end
              end
            else
              socket.close
            end
          else
            context.response.respond_with_status(401)
          end

          socket.on_ping do
            socket.pong
          end
        end
      end
    end
  end
end
