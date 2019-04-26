module Stardust
  module GraphQL
    module DSL

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def object(type, &block)
          Stardust::GraphQL::Collector.add_type(
            type, block, Stardust::GraphQL::Object
          )
        end

        def input_object(type, &block)
          Stardust::GraphQL::Collector.add_type(
            type, block, Stardust::GraphQL::InputObject
          )
        end

        def scalar(type, &block)
          Stardust::GraphQL::Collector.add_type(
            type, block, Stardust::GraphQL::Scalar
          )
        end

        def queries(&block)
          QueryBlock.new(&block)
        end

        def mutations(&block)
          MutationBlock.new(&block)
        end
      end

      class QueryBlock

        def initialize(&block)
          instance_eval &block if block_given?
        end

        def field(name, query:)
          Stardust::GraphQL::Collector.add_query(name, query: query)
        end
      end

      class MutationBlock

        def initialize(&block)
          instance_eval &block if block_given?
        end

        def field(name, mutation:)
          Stardust::GraphQL::Collector.add_mutation(name, mutation: mutation)
        end
      end
    end
  end
end
