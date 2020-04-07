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
        @channel = Channel(Curator::Event).new

        setup
      end

      def send(event : Curator::Event)
        @buffer.push(event)
        flush_buffer
      end

      private def setup
        begin
          connect
        rescue e
        end
        maintain_connection
      end

      private def maintain_connection
        spawn do
          loop do
            sleep 1

            begin
              case @socket
              when HTTP::WebSocket
                @socket.not_nil!.ping
              else
                connect
                flush_buffer
              end
            rescue e
              @socket = nil
            end
          end
        end
      end

      private def flush_buffer
        spawn do
          while can_continue?
            @channel.send(@buffer.shift)
          end
        end

        spawn do
          while can_continue?
            @socket.not_nil!.send(@channel.receive.to_json)
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
