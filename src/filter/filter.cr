module Curator
  class Filter
    getter :event

    def initialize(@event)
    end

    def can_pass?
    end
  end
end
