require "../spec_helper"
require "../../src/forwards/forward"

describe Curator::Forwards::Forward do
  describe "#initialize" do
    it "works!" do
      forward = Curator::Forwards::Forward.new(URI.new("ws://127.0.0.1:3000"), "password")

      forward.buffer.empty?.should eq(true)
      forward.socket.should eq(nil)
    end
  end

  describe "#push" do
    it "adds event to the buffer" do
      event = SpecHelper.get_event({"evt": "presence", "uts": 1580276617006, "org": "", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0})
      forward = Curator::Forwards::Forward.new(URI.new("ws://127.0.0.1:3000"), "password")
      forward.buffer.size.should eq(0)
      forward.push(event)
      forward.buffer.size.should eq(1)
    end
  end
end
