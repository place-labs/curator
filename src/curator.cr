require "./curator/base"

# Entry Point for the server
module Curator
  Curator::Base.new.start
end
