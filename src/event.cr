module Curator
  class Event
    include JSON::Serializable

    getter evt : String
    getter uts : Time
    getter org : String
    getter bld : String
    getter lvl : String
    getter loc : String
    getter src : String
    getter mod : String?
    getter val : Float64
    getter ref : String?
    getter cur : String?
  end
end
