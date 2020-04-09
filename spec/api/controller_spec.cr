require "http/client"

require "../spec_helper"
require "../../src/api/controller"
require "../../src/filter/rules"
require "../../src/transformer/transformer"
require "../../src/forwards/manager"
require "../../src/relay/relay"
require "../../src/utils/auth"

describe Curator::Api::Controller do
  describe "#start" do
    it "accepts request via WebSocket and HTTP POST" do
      rules = Curator::Filter::Rules.new("./spec/fixtures/inclusive_rules.yml", "./spec/fixtures/inclusive_ref_rules.yml")
      transformer = Curator::Transformer.new("TEST-12", "SECRET")
      forwards_manager = Curator::Forwards::Manager.new([{url: URI.parse("ws://127.0.0.1:4000"), api_key: "secret"}])
      relay = Curator::Relay.new(rules: rules, forwards_manager: forwards_manager, transformer: transformer)
      auth = Curator::Utils::Auth.new("TEST-KEY")
      controller = Curator::Api::Controller.new(relay: relay, auth: auth)
      server_channel = Channel(String).new
      spawn do
        controller.start
        server_channel.send("server running")
      end

      spawn do
        # Can connect to socket
        socket = HTTP::WebSocket.new(URI.parse("ws://127.0.0.1:3000/ingest"), HTTP::Headers{"x-api-key" => "TEST-KEY"})
        socket.closed?.should eq(false)

        # Can post event data with correct key
        valid_response = HTTP::Client.post("http://127.0.0.1:3000/ingest",
                                     headers: HTTP::Headers{"x-api-key" => "TEST-KEY"},
                                     body: {"evt": "presence", "uts": 1580276617006, "org": "apple", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0, "mod": "mod-1", "ref": "user@example.com"}.to_json)
        valid_response.status_code.should eq(200)

        # Cannot post event data with incorrect key
        invalid_response = HTTP::Client.post("http://127.0.0.1:3000/ingest",
                                           headers: HTTP::Headers{"x-api-key" => "TEST-WRONG-KEY"},
                                           body: {"evt": "presence", "uts": 1580276617006, "org": "apple", "bld": "bld-1", "lvl": "lvl-1", "loc": "loc-1", "src": "jj@example.com", "val": 1.0, "mod": "mod-1", "ref": "user@example.com"}.to_json)
        invalid_response.status_code.should eq(401)

        controller.stop
        server_channel.receive
      end
    end
  end
end
