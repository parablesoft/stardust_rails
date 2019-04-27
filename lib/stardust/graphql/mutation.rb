module Stardust
  module GraphQL
    class Mutation < ::GraphQL::Schema::Mutation

      def self.argument(name, type, description = nil, loads: nil, **kwargs)
        @__types_to_lookup__ ||= []
        @__types_to_lookup__ << lambda { |klass|
          actual_type = Collector.lookup_type(type)

          kwargs[:prepare] = ->(obj, _ctx) { loads.find(obj) } if loads

          klass.method(:argument)
               .super_method
               .call(name, actual_type, description, **kwargs)
        }
      end

      def self.field(name, type, description = nil, **kwargs)
        @__types_to_lookup__ ||= []
        @__types_to_lookup__ << lambda { |klass|
          actual_type = Collector.lookup_type(type)

          klass.method(:field)
               .super_method
               .call(name, actual_type, description, **kwargs)
        }
      end

      def self.replace_types!
        @__types_to_lookup__.each { |lookup| lookup.call(self) }
      end

      def self.resolve_method
        :resolve_wrapper
      end

      def resolve_wrapper(**kwargs)
        resolve(**kwargs)
      end
    end
  end
end
