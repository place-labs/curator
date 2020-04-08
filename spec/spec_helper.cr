require "spec"
require "webmock"
require "../src/event"

Spec.before_each &->WebMock.reset

module SpecHelper
  extend self

  def get_event(tuple)
    Curator::Event.from_json(tuple.to_json)
  end
end
