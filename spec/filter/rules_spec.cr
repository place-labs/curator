require "../spec_helper"
require "../../src/event"
require "../../src/filter/rules"


describe Curator::Filter::Rules do
  describe "@rules" do
    it "should raise error when rules.yml isnt present" do
      expect_raises(Exception, "Please define rules in nonexistent.yml") do
        Curator::Filter::Rules.new("nonexistent.yml")
      end
    end

    it "has correct rules when rules.yml is present" do
      rules = Curator::Filter::Rules.new("./spec/fixtures/inclusive_rules.yml", "")
      rules.rules.size.should eq(10)
    end

    it "has correct rules when both rules.yml and ref_rules.yml are present" do
      RulesHelper.include_rules.rules.size.should eq(11)
    end
  end

  describe "#pass?" do
    it "when event passes through all inclusive rules it returns true" do
      event = RulesHelper.get_event({"evt": "presence", "uts": 1580276617006, "org": "apple", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0, "mod": "mod-1", "ref": "user@example.com"})
      RulesHelper.include_rules.pass?(event).should eq(true)
    end

    it "when event cant pass through evt rule it returns false" do
      event = RulesHelper.get_event({"evt": "invalid-evt", "uts": 1580276617006, "org": "apple", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0, "mod": "mod-1", "ref": "user@example.com"})
      RulesHelper.include_rules.pass?(event).should eq(false)
    end

    it "when event cant pass through uts rule it returns false" do
      event = RulesHelper.get_event({"evt": "presence", "uts": 1580276617004, "org": "apple", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0, "mod": "mod-1", "ref": "user@example.com"})
      RulesHelper.include_rules.pass?(event).should eq(false)
    end

    it "when event cant pass through org rule it returns false" do
      event = RulesHelper.get_event({"evt": "presence", "uts": 1580276617006, "org": "fb", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0, "mod": "mod-1", "ref": "user@example.com"})
      RulesHelper.include_rules.pass?(event).should eq(false)
    end

    it "when event cant pass through bld rule it returns false" do
      event = RulesHelper.get_event({"evt": "presence", "uts": 1580276617006, "org": "apple", "bld": "bld-2", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0, "mod": "mod-1", "ref": "user@example.com"})
      RulesHelper.include_rules.pass?(event).should eq(false)
    end

    it "when event cant pass through lvl rule it returns false" do
      event = RulesHelper.get_event({"evt": "presence", "uts": 1580276617006, "org": "apple", "bld": "bld-1", "lvl": "lvl-2", "loc": "loc-1", "src": "jj@example.com", "val": 1.0, "mod": "mod-1", "ref": "user@example.com"})
      RulesHelper.include_rules.pass?(event).should eq(false)
    end

    it "when event cant pass through loc rule it returns false" do
      event = RulesHelper.get_event({"evt": "presence", "uts": 1580276617006, "org": "apple", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-2", "src": "jj@example.com", "val": 1.0, "mod": "mod-1", "ref": "user@example.com"})
      RulesHelper.include_rules.pass?(event).should eq(false)
    end

    it "when event cant pass through src rule it returns false" do
      event = RulesHelper.get_event({"evt": "presence", "uts": 1580276617006, "org": "apple", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jjj@example.com", "val": 1.0, "mod": "mod-1", "ref": "user@example.com"})
      RulesHelper.include_rules.pass?(event).should eq(false)
    end

    it "when event cant pass through val rule it returns false" do
      event = RulesHelper.get_event({"evt": "presence", "uts": 1580276617006, "org": "apple", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.1, "mod": "mod-1", "ref": "user@example.com"})
      RulesHelper.include_rules.pass?(event).should eq(false)
    end

    it "when event cant pass through mod rule it returns false" do
      event = RulesHelper.get_event({"evt": "presence", "uts": 1580276617006, "org": "apple", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0, "mod": "mod-2", "ref": "user@example.com"})
      RulesHelper.include_rules.pass?(event).should eq(false)
    end

    it "when event cant pass through ref rule it returns false" do
      event = RulesHelper.get_event({"evt": "presence", "uts": 1580276617006, "org": "apple", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0, "mod": "mod-1", "ref": "user2@example.com"})
      RulesHelper.include_rules.pass?(event).should eq(false)
    end

    it "when event passes through all exclusion rules return true" do
      event = RulesHelper.get_event({"evt": "life-sign", "uts": 1580276617006, "org": "fb", "bld": "bld-2", "lvl": "lvl-2", "loc": "loc-2", "src": "jjj@example.com", "val": 1.1, "mod": "mod-2", "ref": "user2@example.com"})
      RulesHelper.exclude_rules.pass?(event).should eq(true)
    end
  end
end

module RulesHelper
  extend self

  def include_rules
    Curator::Filter::Rules.new("./spec/fixtures/inclusive_rules.yml", "./spec/fixtures/inclusive_ref_rules.yml")
  end

  def exclude_rules
    Curator::Filter::Rules.new("./spec/fixtures/exclusion_rules.yml", "./spec/fixtures/exclusion_ref_rules.yml")
  end

  def get_event(tuple)
    Curator::Event.from_json(tuple.to_json)
  end
end
