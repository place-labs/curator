module Curator
  module Api
    module Helpers
      private def request_path(http_context)
        http_context.request.resource
      end

      private def request_method(http_context)
        http_context.request.method
      end

      private def to_event(data)
        Curator::Event.from_json(data)
      end
    end
  end
end
