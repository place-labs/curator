require "http/server/handler"
require "./helpers"

module Curator
  # Handles the HTTP POST call for `/ingest` endpoint.
  class HttpHandler
    include HTTP::Handler
    include Curator::Api::Helpers

    getter :relay, :auth

    def initialize(@relay : Curator::Relay, @auth : Curator::Utils::Auth)
    end

    def call(context)
      if auth.valid?(context)
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
