require "../api/controller"
require "../filter/rules"
require "../forwards/manager"
require "../relay/relay"
require "../transformer/transformer"

module Curator
  class Base
    CONFIG_PATH = "config/config.yml"
    getter :config, :controller
    @config : YAML::Any

    def initialize
      @config = load_config
      rules = Curator::Filter::Rules.new
      transformer = Curator::Transformer.new(config: @config)
      forwards_manager = Curator::Forwards::Manager.new(config: @config)
      relay = Curator::Relay.new(rules: rules, forwards_manager: forwards_manager, transformer: transformer)
      @controller = Curator::Api::Controller.new(config: @config, relay: relay)
    end

    private def load_config
      raise "Please define config in config/config.yml" unless File.exists?(CONFIG_PATH)

      File.open(CONFIG_PATH) do |file|
        YAML.parse(file)
      end
    end
  end
end
