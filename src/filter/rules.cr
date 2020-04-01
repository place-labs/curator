require "yaml"
require "./rule"
require "./uts_rule"

module Curator
  class Filter
    class Rules
      RULES_PATH     = "config/rules.yml"
      REF_RULES_PATH = "config/ref_rules.yml"

      getter :rules
      @rules : Array(Rule | UtsRule) = [] of Rule | UtsRule

      def initialize
        @rules = rules_config.as_a.map do |config|
          to_rule(config)
        end
        @rules += ref_rules_config.as_a.map do |config|
          to_rule(config)
        end
      end

      def pass?(event : Event) : Bool
        rules.all? do |rule|
          rule.pass?(event)
        end
      end

      private def rules_config
        raise "Please define rules in config/rules.yml" unless File.exists?(RULES_PATH)

        File.open(RULES_PATH) do |file|
          YAML.parse(file)
        end
      end

      private def ref_rules_config
        if File.exists?(REF_RULES_PATH)
          File.open(REF_RULES_PATH) do |file|
            YAML.parse(file)
          end
        else
          YAML::Any.new([] of YAML::Any)
        end
      end

      private def to_rule(config)
        attribute = config["attribute"].as_s
        operation = config["operation"].as_s
        values = config["values"].as_a.map(&.as_s)

        if attribute == "uts"
          UtsRule.new(attribute: attribute, operation: operation, values: values)
        else
          Rule.new(attribute: attribute, operation: operation, values: values)
        end
      end
    end
  end
end
