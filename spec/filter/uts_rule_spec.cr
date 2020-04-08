require "../spec_helper"
require "../../src/filter/uts_rule"

describe Curator::Filter::UtsRule do
  describe "#pass?" do
    describe "greater_than_equal" do
      it "passes when rule value is greater than attribute val" do
        event = SpecHelper.get_event({"evt": "presence", "uts": 1580276617006, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0})
        rule = Curator::Filter::UtsRule.new("uts", "greater_than_equal", [1580276617005])
        rule.pass?(event).should eq(true)
      end

      it "passes when rule value is equal to attribute val" do
        event = SpecHelper.get_event({"evt": "presence", "uts": 1580276617005, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0})
        rule = Curator::Filter::UtsRule.new("uts", "greater_than_equal", [1580276617005])
        rule.pass?(event).should eq(true)
      end

      it "does not pass when rule value less than attribute val" do
        event = SpecHelper.get_event({"evt": "presence", "uts": 1580276617004, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0})
        rule = Curator::Filter::UtsRule.new("uts", "greater_than_equal", [1580276617005])
        rule.pass?(event).should eq(false)
      end
    end

    describe "less_than_equal" do
      it "passes when rule value is less than attribute val" do
        event = SpecHelper.get_event({"evt": "presence", "uts": 1580276617004, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0})
        rule = Curator::Filter::UtsRule.new("uts", "less_than_equal", [1580276617005])
        rule.pass?(event).should eq(true)
      end

      it "passes when rule value is equal to attribute val" do
        event = SpecHelper.get_event({"evt": "presence", "uts": 1580276617005, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0})
        rule = Curator::Filter::UtsRule.new("uts", "less_than_equal", [1580276617005])
        rule.pass?(event).should eq(true)
      end

      it "does not pass when rule value greater than attribute val" do
        event = SpecHelper.get_event({"evt": "presence", "uts": 1580276617104, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0})
        rule = Curator::Filter::UtsRule.new("uts", "less_than_equal", [1580276617005])
        rule.pass?(event).should eq(false)
      end
    end
  end
end
