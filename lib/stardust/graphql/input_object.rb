module Stardust
  module GraphQL
    class InputObject < ::GraphQL::Schema::InputObject

      def self.argument(name, type, description = nil, **kwargs, &block)

        @__types_to_lookup__ ||= []
        @__types_to_lookup__ << ->(klass) {
          actual_type = Collector.lookup_type(type)

          klass
          .method(:argument)
          .super_method
          .call(name, actual_type, description, **kwargs, &block)

        }
      end

      def self.replace_types!
        @__types_to_lookup__.each {|lookup| lookup.(self)}
      end
    end
  end
end
