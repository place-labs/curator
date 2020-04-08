require "../api/controller"
require "../filter/rules"
require "../forwards/manager"
require "../relay/relay"
require "../transformer/transformer"

module Curator
  class Base
    getter :controller

    def initialize
      rules = Curator::Filter::Rules.new
      transformer = Curator::Transformer.new
      forwards_manager = Curator::Forwards::Manager.new
      relay = Curator::Relay.new(rules: rules, forwards_manager: forwards_manager, transformer: transformer)
      @controller = Curator::Api::Controller.new(relay: relay)
    end

    def start
      controller.start
    end
  end
end
