require "../forwards/forward"

module Curator
  module Forwards
    # Responsible for reading the `ENV["FORWARDS"]` and instantiating
    # an Array of `Curator::Forwards::Forward`
    class Manager
      getter :forwards, :retry_queue

      def initialize(forwards_tuple : Array(NamedTuple(url: URI, api_key: String)) = env_forwards)
        @forwards = [] of Curator::Forwards::Forward
        initialize_forwards(forwards_tuple)
      end

      private def initialize_forwards(forwards_tuple)
        @forwards = forwards_tuple.map do |forward|
          Curator::Forwards::Forward.new(url: forward[:url], api_key: forward[:api_key])
        end
      end

      # FORWARDS = "url1|api_key1 url2|api_key2"
      # e.g. FORWARDS="ws://127.0.0.1:4444|firstapikey ws://127.0.0.1:5555|secondapikey"
      private def env_forwards : Array(NamedTuple(url: URI, api_key: String))
        fwds = ENV["FORWARDS"].split(" ")
        fwds.map do |fwd|
          url, key = fwd.split("|")
          {
            url:     URI.parse(url),
            api_key: key,
          }
        end
      end
    end
  end
end
