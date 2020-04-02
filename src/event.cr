require "json"

module Curator
  class Event
    include JSON::Serializable

    getter evt : String
    getter uts : Int64
    getter org : String
    getter bld : String
    getter lvl : String
    getter loc : String
    getter src : String
    getter mod : String?
    getter val : Float64
    getter ref : String?
    getter cur : String?

    def blank?(attribute : String) : Bool
      val = value(attribute)
      val.nil? || val == ""
    end

    def value(attribute : String)
      hash = to_h
      hash[attribute]
    end

    def to_h
      {
        "evt" => evt,
        "uts" => uts,
        "org" => org,
        "bld" => bld,
        "lvl" => lvl,
        "loc" => loc,
        "src" => src,
        "mod" => mod,
        "val" => val,
        "ref" => ref,
        "cur" => cur,
      }
    end
  end
end
