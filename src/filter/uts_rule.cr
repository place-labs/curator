module Curator
  class Filter
    class UtsRule
      enum Operation
        GreaterThanEqual
        LessThanEqual
      end

      @operation : Operation
      @values : Array(Int64)

      def initialize(@attribute : String, operation : String, values : Array(String))
        @operation = Operation.parse(operation)
        @values = values.map(&.to_i64)
      end
    end
  end
end
