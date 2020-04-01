module Curator
  class Filter
    class Rule
      enum Operation
        Include
        Exclude
      end

      @operation : Operation

      def initialize(@attribute : String, operation : String, @values : Array(String))
        @operation = Operation.parse(operation)
      end

      def pass?(event : Event)
      end
    end
  end
end
