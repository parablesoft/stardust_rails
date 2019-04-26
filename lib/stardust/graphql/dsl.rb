module Stardust
  module GraphQL
    module DSL

      def define_types(&block)
        klass = Class.new(Types::DSL)
        klass.class_eval(&block)
      end

      def define_query(name, &block)
        klass = Class.new(Query)
        klass.class_eval(&block)
        Collector.add_query(name, query: klass)
      end

      def define_mutation(name, &block)
        klass = Class.new(Mutation)
        klass.send(:graphql_name, name.to_s.camelize)
        klass.class_eval(&block)
        Collector.add_mutation(name, mutation: klass)
      end

    end
  end
end
