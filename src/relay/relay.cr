module Curator
  # Responsible for applying the filters for an event
  # And if the event passes the filter,
  # applying the transformation on the event, i.e pepper the `ref` and appending the `cur`
  # relaying them to the available forwards.
  class Relay
    getter :rules, :forwards_manager, :transformer

    def initialize(@rules : Curator::Filter::Rules, @forwards_manager : Curator::Forwards::Manager, @transformer : Curator::Transformer)
    end

    # Performs following
    # 1. Apply Filters
    # 2. Transform the event
    # 3. Hand it to available Forwards
    def call(event : Curator::Event)
      if rules.pass?(event)
        transformed_event = transformer.call(event)
        handle_forwards(transformed_event)
      end
    end

    private def handle_forwards(event : Curator::Event)
      fwds = forwards_manager.forwards

      fwds.each do |forward|
        forward.push(event)
      end
    end
  end
end
