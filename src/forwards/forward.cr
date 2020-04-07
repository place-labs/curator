require "../utils/ring_buffer"

module Curator
  module Forwards
    class Forward
      getter :url, :api_key
      property socket : HTTP::WebSocket?
      property buffer : Curator::Utils::RingBuffer

      def initialize(@url : URI, @api_key : String)
        buffer_size = ENV.has_key?("BUFFER_SIZE") ? ENV["BUFFER_SIZE"].to_i : 50000
        @buffer = Curator::Utils::RingBuffer.new(buffer_size)

        setup
      end

      def send(event)
        @buffer.push(event)
      end

      private def setup
        begin
          connect
        rescue e
        end
        maintain_connection
        start_flush_buffer_loop
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
              end
            rescue e
              @socket = nil
            end
          end
          start_flush_buffer_loop
        end
      end

      private def start_flush_buffer_loop
        spawn do
          loop do
            # 10,000 events per sec
            sleep 0.0001

            case @socket
            when HTTP::WebSocket
              @socket.not_nil!.send(@buffer.shift.to_json) if !@buffer.empty?
            end
          end
        end
      end

      private def connect
        @socket = HTTP::WebSocket.new(url, HTTP::Headers{"x-api-key" => api_key})
      end
    end
  end
end
