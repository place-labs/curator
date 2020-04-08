require "json"

module Curator
  # Responsible for translating incoming `event` json data into a crystal object
  # Adds some utility methods to ease interacting with `event`
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
    property ref : String?
    property cur : String?

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
