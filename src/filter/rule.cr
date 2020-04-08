module Curator
  class Filter
    # Responsible for defining filter for all `Event` attributes except `Event.uts` attribute.
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

      # Filter the event based on
      # * event attribute value
      # * rule `operation`
      # * rule `values`
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
