require "http/server/handler"
require "./helpers"

module Curator
  class HttpHandler
    include HTTP::Handler
    include Curator::Api::Helpers

    getter :config, :relay

    def initialize(@config : YAML::Any, @relay : Curator::Relay)
    end

    def call(context)
      if authenticated?(context)
        case {request_path(context), request_method(context)}
        when {"/ingest", "POST"}
          process_events(context)
        else
          call_next(context)
        end
      else
        context.response.respond_with_status(401)
      end
    end

    private def process_events(context)
      body = context.request.body.not_nil!.gets_to_end
      body.each_line do |line|
        begin
          relay.call(to_event(line))
        rescue e
        end
      end
    end
  end
end
