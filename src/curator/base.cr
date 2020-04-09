require "../api/controller"
require "../filter/rules"
require "../forwards/manager"
require "../relay/relay"
require "../transformer/transformer"
require "../utils/auth"

module Curator
  # Base Class responsible for instantiating all relevant components
  # and handing them over.
  class Base
    getter :controller

    def initialize
      rules = Curator::Filter::Rules.new
      transformer = Curator::Transformer.new
      forwards_manager = Curator::Forwards::Manager.new
      relay = Curator::Relay.new(rules: rules, forwards_manager: forwards_manager, transformer: transformer)
      auth = Curator::Utils::Auth.new
      @controller = Curator::Api::Controller.new(relay: relay, auth: auth)
    end

    def start
      controller.start
    end
  end
end
