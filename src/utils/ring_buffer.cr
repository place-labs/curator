module Curator
  module Utils
    class RingBuffer
      property list : Array(Curator::Event)

      delegate empty?, shift, to: @list

      def initialize(@max_size : Int32)
        @list = [] of Curator::Event
      end

      def push(event : Curator::Event)
        if @list.size < @max_size
          @list.push(event)
        else
          @list.shift
          @list.push(event)
        end
      end
    end
  end
end
