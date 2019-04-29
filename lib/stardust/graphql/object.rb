module Stardust
  module GraphQL
    class Object < ::GraphQL::Schema::Object

      field_class Field

      def self.field(name, type, description = nil, **kwargs, &block)

        @__types_to_lookup__ ||= []
        @__types_to_lookup__ << ->(klass) {
          actual_type = Collector.lookup_type(type)

          klass
          .method(:field)
          .super_method
          .call(name, actual_type, description, **kwargs, &block)
        }
      end

      def self.replace_types!
        return unless @__types_to_lookup__
        @__types_to_lookup__.each {|lookup| lookup.(self)}
      end

      def current_user
        context[:current_user]
      end
    end
  end
end
