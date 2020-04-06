module Curator
  class Relay
    getter :rules, :forwards_manager, :transformer

    def initialize(@rules : Curator::Filter::Rules, @forwards_manager : Curator::Forwards::Manager, @transformer : Curator::Transformer)
    end

    def call(event : Curator::Event)
      if rules.pass?(event)
        transformed_event = transformer.call(event)
        handle_forwards(transformed_event)
      end
    end

    private def handle_forwards(event : Curator::Event)
      fwds = forwards_manager.forwards

      fwds.each do |forward|
        forward.send(event.to_json)
      end
    end
  end
end
