module Curator
  class Filter
    class Rule
      enum Operation
        Include
        Exclude
      end

      getter :attribute, :operation, :values

      @operation : Operation
      @values : Array(Float64) | Array(String)

      def initialize(@attribute : String, operation : String, values : Array(String))
        @operation = Operation.parse(operation)
        @values = case attribute
                  when "val"
                    values.map(&.to_f64)
                  else
                    values
                  end
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
