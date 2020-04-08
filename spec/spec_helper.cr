require "spec"
require "../src/event"

module SpecHelper
  extend self

  def get_event(tuple)
    Curator::Event.from_json(tuple.to_json)
  end
end
