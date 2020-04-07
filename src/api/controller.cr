require "http/server"
require "json"
require "../event"
require "./helpers"
require "./http_handler"
require "../relay/relay"

module Curator
  module Api
    class Controller
      include Curator::Api::Helpers
      getter :port, :relay
      @port : Int32

      def initialize(@relay : Curator::Relay)
        @port = ENV.has_key?("PORT") ? ENV["PORT"].to_i : 3000
      end

      def start
        server = HTTP::Server.new([ws_handler, HttpHandler.new(relay)])
        address = server.bind_tcp(port)
        puts "Listening on ws://#{address}"
        puts "Listening on http://#{address}"
        server.listen
      end

      def ws_handler
        HTTP::WebSocketHandler.new do |socket, context|
          if authenticated?(context)
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
