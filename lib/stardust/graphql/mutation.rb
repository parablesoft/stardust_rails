module Stardust
  module GraphQL
    class Mutation < ::GraphQL::Schema::Mutation

      def current_user
        context[:current_user]
      end

      def self.get_null
        @null
      end

      def self.argument(name, type, description = nil, loads: nil, **kwargs)
        @__types_to_lookup__ ||= []
        the_file = caller[0][/[^:]+/].gsub(Rails.root.to_s, "")
        the_line = caller[0].split(":")[1]
        @__types_to_lookup__ << lambda { |klass|
          begin
            actual_type = Collector.lookup_type(type)

            kwargs[:prepare] = ->(obj, _ctx) { loads.find(obj) } if loads

            klass.method(:argument)
                 .super_method
                 .call(name, actual_type, description, **kwargs)
          rescue MissingType => e
            warn <<~TEXT

              Stardust Compilation Warning
                - MESSAGE: Type #{e.message} is not defined.
                - RESULT:  This mutation is not added to the graph.
                - FILE:    #{the_file}
                - LINE:    #{the_line}

            TEXT
          end
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
        return unless @__types_to_lookup__
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
