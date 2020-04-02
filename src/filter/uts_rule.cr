module Curator
  class Filter
    class UtsRule
      enum Operation
        GreaterThanEqual
        LessThanEqual
      end

      getter :attribute, :operation, :values

      @operation : Operation

      def initialize(@attribute : String, operation : String, @values : Array(Int64))
        @operation = Operation.parse(operation)
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
