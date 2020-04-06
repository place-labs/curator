module Curator
  class Relay
    getter :event, :rules, :forwards_manager

    def initialize(@config : YAML::Any, @rules : Curator::Filter::Rules, @forwards_manager : Curator::Forwards::Manager)
    end

    def call(event : Curator::Event)
      if rules.pass?(event)
        handle_forwards(event)
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
