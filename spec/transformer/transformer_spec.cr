require "../spec_helper"
require "../../src/event"
require "../../src/transformer/transformer"

describe Curator::Transformer do
  describe "first curator in chain" do
    it "correctly modifies ref and cur for an event" do
      event = SpecHelper.get_event({"evt": "life-sign", "uts": 1580276617006, "org": "fb", "bld": "bld-2", "lvl": "lvl-2", "loc": "loc-2", "src": "jjj@example.com", "val": 1.1, "mod": "mod-2", "ref": "user2@example.com"})

      transformer = Curator::Transformer.new("cur-test", "secret")
      transformed_event = transformer.call(event)

      transformed_event.ref.should eq("6ac9dfb457b81169df96cc5c276c5e9cc2595bd9ca26771087f68b5f20efdb66")
      transformed_event.cur.should eq("cur-test")
    end
  end

  describe "second curator in chain" do
    it "correctly modifies ref and cur for an event" do
      event = SpecHelper.get_event({"evt": "life-sign", "uts": 1580276617006, "org": "fb", "bld": "bld-2", "lvl": "lvl-2", "loc": "loc-2", "src": "jjj@example.com", "val": 1.1, "mod": "mod-2", "ref": "user2@example.com"})

      transformer = Curator::Transformer.new("cur-test", "secret")
      transformed_event = transformer.call(event)

      second_transformer = Curator::Transformer.new("cur-test2", "secret")
      second_transformed_event = second_transformer.call(transformed_event)

      second_transformed_event.ref.should eq("e9bccb0224f613b7e6b7cfa2613088e4b638d4a364ab97bf129a9c15a4fe069c")
      second_transformed_event.cur.should eq("cur-test.cur-test2")
    end
  end
end
