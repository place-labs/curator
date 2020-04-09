module Curator
  module Utils
    class Auth
      getter :api_key

      def initialize(@api_key : String = ENV["API_KEY"])
      end

      def valid?(http_context)
        key = http_context.request.headers["x-api-key"]?

        return false if key.nil?

        key == api_key
      end
    end
  end
end
