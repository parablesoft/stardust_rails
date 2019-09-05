module Stardust
  module GraphQL
    module Interface

      def self.included(base)
        base.module_eval do
          include ::GraphQL::Schema::Interface

          def self.graphql_name(name = nil)
            if name
              @__graphql_name__ = name
            else
              @__graphql_name__
            end
          end

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
        end
        base
      end

    end
  end
end
