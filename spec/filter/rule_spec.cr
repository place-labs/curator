require "../spec_helper"
require "../../src/event"
require "../../src/filter/rule"

describe Curator::Filter::Rule do
  describe "#pass?" do
    describe "include" do
      describe "blank" do
        it "allows when rule values has 'blank' and event attribute is empty string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "include", ["blank"])
          rule.pass?(event).should eq(true)
        end

        it "does not allow when rule values has 'blank' and event attribute is not empty string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "test", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "include", ["blank"])
          rule.pass?(event).should eq(false)
        end
      end

      describe "non blank" do
        it "allows when rule values has 'non-blank' and event attribute is same string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "test", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "include", ["test"])
          rule.pass?(event).should eq(true)
        end

        it "does not allow when rule values has 'non-blank' and event attribute is empty string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "include", ["test"])
          rule.pass?(event).should eq(false)
        end
      end

      describe "blank + non blank" do
        it "allows when rule values has both blank and non-blank value and event attribute is same string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "test", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "include", ["test", "blank"])
          rule.pass?(event).should eq(true)
        end

        it "allows when rule values has both blank and non-blank value and event attribute is empty string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "include", ["test", "blank"])
          rule.pass?(event).should eq(true)
        end
      end

      describe "no value" do
        it "does not allow when rule values has no values and event attribute is some string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "test", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "include", [] of String)
          rule.pass?(event).should eq(false)
        end

        it "does not allow when rule values has no values and event attribute is blank string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "include", [] of String)
          rule.pass?(event).should eq(false)
        end
      end
    end

    describe "exclude" do
      describe "blank" do
        it "does not allow when rule values has 'blank' and event attribute is empty string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "exclude", ["blank"])
          rule.pass?(event).should eq(false)
        end

        it "allows when rule values has 'blank' and event attribute is not empty string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "test", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "exclude", ["blank"])
          rule.pass?(event).should eq(true)
        end
      end

      describe "non blank" do
        it "does not allow when rule values has 'non-blank' and event attribute is same string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "test", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "exclude", ["test"])
          rule.pass?(event).should eq(false)
        end

        it "allows when rule values has 'non-blank' and event attribute is empty string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "exclude", ["test"])
          rule.pass?(event).should eq(true)
        end
      end

      describe "blank + non blank" do
        it "does not allow when rule values has both blank and non-blank value and event attribute is same string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "test", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "exclude", ["test", "blank"])
          rule.pass?(event).should eq(false)
        end

        it "does not allow when rule values has both blank and non-blank value and event attribute is empty string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "exclude", ["test", "blank"])
          rule.pass?(event).should eq(false)
        end
      end

      describe "no value" do
        it "allows when rule values has no values and event attribute is some string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "test", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "exclude", [] of String)
          rule.pass?(event).should eq(true)
        end

        it "allows when rule values has no values and event attribute is blank string" do
          event_tuple = {"evt": "presence", "uts": 1580276617006, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0}
          event = Curator::Event.from_json(event_tuple.to_json)
          rule = Curator::Filter::Rule.new("org", "exclude", [] of String)
          rule.pass?(event).should eq(true)
        end
      end
    end
  end
end
