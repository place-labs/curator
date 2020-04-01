module Curator
  class Filter
    class UtsRule
      enum Operation
        GreaterThanEqual
        LessThanEqual
      end

      getter :attribute, :operation, :values

      @operation : Operation
      @values : Array(Int64)

      def initialize(@attribute : String, operation : String, values : Array(String))
        @operation = Operation.parse(operation)
        @values = values.map(&.to_i64)
      end

      def pass?(event : Event) : Bool
        val = event.value(attribute)
        case {operation, val}
        when {Operation::GreaterThanEqual, Int64}
          val >= values.first
        when {Operation::LessThanEqual, Int64}
          val <= values.first
        else
          false
        end
      end
    end
  end
end
