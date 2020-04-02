require "../api/controller"
require "../filter/rules"
require "../relay/relay"

module Curator
  class Base
    CONFIG_PATH = "config/config.yml"
    getter :config, :controller
    @config : YAML::Any
    @forwards : Array(HTTP::WebSocket)

    def initialize
      @config = load_config
      @forwards = load_forwards
      @rules = Curator::Filter::Rules.new
      @relay = Curator::Relay.new(config: @config, rules: @rules, forwards: @forwards)
      @controller = Curator::Controller.new(config: @config, relay: @relay)
    end

    private def load_config
      raise "Please define config in config/config.yml" unless File.exists?(CONFIG_PATH)

      File.open(CONFIG_PATH) do |file|
        YAML.parse(file)
      end
    end

    private def load_forwards
      config["forwards"].as_a.map do |forward|
        HTTP::WebSocket.new(URI.parse(forward["url"].as_s),
                            HTTP::Headers{"x-api-key" => forward["api_key"].as_s})
      end
    end
  end
end
