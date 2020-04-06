require "openssl"

module Curator
  class Transformer
    getter :config, :curator_id, :pepper
    @curator_id : String
    @pepper : String

    def initialize(@config : YAML::Any)
      @curator_id = @config["curator_id"].as_s
      @pepper = @config["pepper"].as_s
    end

    def call(event : Curator::Event) : Curator::Event
      event.ref = peppered_ref(event.ref)
      event.cur = append_curator_id(event.cur)
      event
    end

    private def peppered_ref(ref : String?)
      OpenSSL::Digest.new("SHA256").update("#{ref}#{pepper}").to_s
    end

    private def append_curator_id(cur : String?)
      case cur
      when nil
        curator_id
      else
        "#{cur}.#{curator_id}"
      end
    end
  end
end
