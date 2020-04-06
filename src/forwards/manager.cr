module Curator
  module Forwards
    class Manager
      getter :config, :forwards, :retry_queue

      def initialize(@config : YAML::Any)
        @forwards = [] of HTTP::WebSocket
        @retry_queue = [] of NamedTuple(url: URI, api_key: String)
        start_reconnect_loop
        load_forwards
      end

      private def load_forwards
        config["forwards"].as_a.map do |forward|
          setup_socket({url: URI.parse(forward["url"].as_s), api_key: forward["api_key"].as_s})
        end
      end

      private def setup_socket(forward)
        begin
          socket = HTTP::WebSocket.new(forward[:url],
            HTTP::Headers{"x-api-key" => forward[:api_key]})

          maintain_forwards(socket, forward)

          @forwards << socket
        rescue e
          append_to_retry(forward)
        end
      end

      private def start_reconnect_loop
        spawn do
          loop do
            sleep 3

            retry_queue.each do |forward|
              begin
                socket = HTTP::WebSocket.new(forward[:url],
                  HTTP::Headers{"x-api-key" => forward[:api_key]})
                @forwards << socket
                retry_queue.delete(forward)
              rescue e
              end
            end
          end
        end
      end

      def maintain_forwards(socket, forward)
        spawn do
          loop do
            sleep 3

            begin
              socket.ping
            rescue e
              @forwards.delete(socket)
              append_to_retry(forward)
              break
            end
          end
        end
      end

      private def append_to_retry(forward : NamedTuple(url: URI, api_key: String))
        @retry_queue << forward
      end
    end
  end
end
