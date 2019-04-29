module Stardust
  module GraphQL
    module Collector
      module_function

      FIXED_TYPES = {
        id: ::GraphQL::Types::ID,
        int: Integer,
        integer: Integer,
        float: Float,
        string: String,
        date: ::GraphQL::Types::ISO8601DateTime,
        datetime: ::GraphQL::Types::ISO8601DateTime,
        boolean: ::GraphQL::Types::Boolean,
      }.freeze


      @@__types__ = {}.merge(FIXED_TYPES)
      @@__defined_types__ = []
      @@__queries__ = {}
      @@__mutations__ = {}

      def add_type(type, block, object_klass)
        if type.in?(@@__types__.keys)
          raise "Type #{type.to_s} is alread defined."
        end

        @@__defined_types__ << type.to_s.camelize

        klass = Class.new(object_klass, &block)

        begin
          klass.graphql_name
        rescue NotImplementedError
          klass.graphql_name(type.to_s.camelize)
        end
        
        ::Stardust::GraphQL::Types.const_set("#{type.to_s.camelize}", klass)
        @@__types__[type] = "Stardust::GraphQL::Types::#{type.to_s.camelize}".constantize
      end

      def self.clear_definitions!
        @@__defined_types__ = []
        @@__types__ = {}.merge(FIXED_TYPES)
        @@__queries__ = {}
        @@__mutations__ = {}

        ::Stardust::GraphQL.send(:remove_const, "Types")
        ::Stardust::GraphQL.send(:remove_const, "Schema")
        load 'stardust/graphql/types'
        load 'stardust/graphql/schema'
      end

      def add_query(name, query:)
        if name.in?(@@__queries__.keys)
          raise "Query #{name.to_s} is already defined."
        end
        @@__queries__[name] = query
      end

      def add_mutation(name, mutation:)
        if name.in?(@@__queries__.keys)
          raise "Mutation #{name.to_s} is already defined."
        end
        @@__mutations__[name] = mutation
      end

      def self.types
        @@__types__
      end

      def self.queries
        @@__queries__
      end

      def self.lookup_type(type)
        if type.is_a?(Array)
          type = type.first
          is_a_array = true
        end

        raise MissingType, type.to_s unless @@__types__[type]

        if is_a_array
          [@@__types__[type]]
        else
          @@__types__[type]
        end
      end

      def self.replace_types!
        @@__types__.values.each do |klass|
          begin
            klass.replace_types! if klass.respond_to?(:replace_types!)
          rescue MissingType => e
            warn <<~TEXT

              Stardust Compilation Error
              Type #{e.message} is not defined.

            TEXT
          end
        end

        query_class = Class.new(::Stardust::GraphQL::Object)
        query_class.graphql_name("QueryRoot")
        @@__queries__.each do |name, query|

          block = ->(field) {

            query.get_arguments.each do |name, type, description, kwargs, block|
              field.argument(name, type, description, **kwargs, &block)
            end

            field.instance_variable_set(:@resolver_class, query)
            field.instance_variable_set(:@resolver_method, :resolve)
            field.extension(Extensions::Authorize)
          }

          query_class.send(:field,
            name,
            query.get_type,
            query.get_description,
            null: query.get_null,
            &block
          )
        end

        begin
          query_class.replace_types!
        rescue MissingType => e
          warn <<~TEXT

            Stardust Compilation Error
            Type #{e.message} is not defined.

          TEXT
        end
        Schema.query(query_class)


        mutation_class = Class.new(::GraphQL::Schema::Object)
        mutation_class.graphql_name("MutationRoot")
        @@__mutations__.each do |name, mutation|
          begin
            mutation.replace_types!
            mutation_class.send(:field, name, mutation: mutation )
          rescue MissingType => e
            warn <<~TEXT

              Stardust Compilation Error
              Type #{e.message} is not defined.

            TEXT
          end
        end
        Schema.mutation(mutation_class)
      end
    end
  end
end
