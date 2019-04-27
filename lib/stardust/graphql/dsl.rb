module Stardust
  module GraphQL
    module DSL

      class MissingType < StandardError; end;

      def define_types(&block)
        klass = Class.new(Types::DSL)
        klass.class_eval(&block)
      end

      def define_query(name, &block)
        klass = Class.new(Query)
        klass.class_eval(&block)
        if !klass.get_type
          warn <<~TEXT

            Stardust Compilation Error
            Missing type definition for query in "#{name}".
            File: "#{calling_file}"

              ## Define the return type of the query
              type :my_type

          TEXT
        else
          Collector.add_query(name, query: klass)
        end
      end

      def define_mutation(name, &block)
        klass = Class.new(Mutation)
        klass.send(:graphql_name, name.to_s.camelize)
        klass.class_eval(&block)
        Collector.add_mutation(name, mutation: klass)
      end

      def calling_file
        caller[1][/[^:]+/]
        .gsub(Rails.root.to_s, "")[1..-1]
      end

    end
  end
end
