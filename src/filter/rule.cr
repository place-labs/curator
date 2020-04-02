module Curator
  class Filter
    class Rule
      enum Operation
        Include
        Exclude
      end

      getter :attribute, :operation, :values

      @operation : Operation


      def initialize(@attribute : String, operation : String, @values : Array(Float64) | Array(String))
        @operation = Operation.parse(operation)
      end

      def pass?(event : Event) : Bool
        case operation
        when Operation::Include
          return true if event.blank?(attribute) && values.includes?("blank")
          return true if values.includes?(event.value(attribute))

          false
        when Operation::Exclude
          return false if event.blank?(attribute) && values.includes?("blank")
          return false if values.includes?(event.value(attribute))

          true
        else
          false
        end
      end
    end
  end
end
