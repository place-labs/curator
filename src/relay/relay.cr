module Curator
  class Relay
    getter :event, :rules, :forwards

    def initialize(@config : YAML::Any, @rules : Curator::Filter::Rules, @forwards : Array(HTTP::WebSocket))
    end

    def call(event : Curator::Event)
      if rules.pass?(event)
        handle_forwards(event.to_json)
      end
    end

    private def handle_forwards(message)
      forwards.each do |forward|
        forward.send(message)
      end
    end
  end
end
