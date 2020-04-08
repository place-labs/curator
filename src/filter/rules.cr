require "yaml"
require "./rule"
require "./uts_rule"

module Curator
  class Filter
    class Rules
      getter :rules
      @rules : Array(Rule | UtsRule) = [] of Rule | UtsRule

      def initialize(rules_path : String = "config/rules.yml",  ref_rules_path : String = "config/ref_rules.yml")
        @rules = rules_config(rules_path).as_a.map do |config|
          to_rule(config)
        end
        @rules += ref_rules_config(ref_rules_path).as_a.map do |config|
          to_rule(config)
        end
      end

      def pass?(event : Event) : Bool
        rules.all? do |rule|
          rule.pass?(event)
        end
      end

      private def rules_config(rules_path : String)
        raise "Please define rules in #{rules_path}" unless File.exists?(rules_path)

        File.open(rules_path) do |file|
          YAML.parse(file)
        end
      end

      private def ref_rules_config(ref_rules_path : String)
        if File.exists?(ref_rules_path)
          File.open(ref_rules_path) do |file|
            YAML.parse(file)
          end
        else
          YAML::Any.new([] of YAML::Any)
        end
      end

      private def to_rule(config)
        attribute = config["attribute"].as_s
        operation = config["operation"].as_s

        if attribute == "uts"
          values = config["values"].as_a.map(&.as_i64)
          UtsRule.new(attribute: attribute, operation: operation, values: values)
        elsif attribute == "val"
          values = config["values"].as_a.map(&.as_f)
          Rule.new(attribute: attribute, operation: operation, values: values)
        else
          values = config["values"].as_a.map(&.as_s)
          Rule.new(attribute: attribute, operation: operation, values: values)
        end
      end
    end
  end
end
