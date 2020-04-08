require "http/server"
require "../utils/ring_buffer"

module Curator
  module Forwards
    class Forward
      getter :url, :api_key
      property socket : HTTP::WebSocket?
      property buffer : Curator::Utils::RingBuffer

      def initialize(@url : URI, @api_key : String)
        buffer_size = ENV.has_key?("BUFFER_SIZE") ? ENV["BUFFER_SIZE"].to_i : 100000
        @buffer = Curator::Utils::RingBuffer.new(buffer_size)

        maintain_connection
        maintain_flush_buffer_loop
      end

      def push(event : Curator::Event)
        @buffer.push(event)
      end

      private def maintain_connection
        spawn do
          loop do
            sleep 1

            begin
              ping_or_connect
            rescue e
              @socket = nil
            end
          end
        end
      end

      private def ping_or_connect
        case @socket
        when HTTP::WebSocket
          @socket.not_nil!.ping
        else
          connect
        end
      end

      private def maintain_flush_buffer_loop
        spawn do
          loop do
            # Polling 10000 times a second
            sleep 0.00001

            begin
              @socket.not_nil!.send(@buffer.shift.to_json) if can_continue?
            rescue e
              @socket = nil
            end
          end
        end
      end

      private def can_continue?
        !@socket.nil? && !@buffer.empty?
      end

      private def connect
        @socket = HTTP::WebSocket.new(url, HTTP::Headers{"x-api-key" => api_key})
      end
    end
  end
end
