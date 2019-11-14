require 'apollo-federation/entities_field'
require 'apollo-federation/service_field'
require 'apollo-federation/any'

module Stardust
  module GraphQL
    module Collector
      module_function

      FIXED_TYPES = {
        any: ApolloFederation::Any,
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
      @@__lookedup_types__ = []

      def add_type(type, block, object_klass)
        if type.in?(@@__types__.keys)
          raise "Type #{type.to_s} is alread defined."
        end

        @@__defined_types__ << type.to_s.camelize

        klass = nil
        if object_klass.is_a?(Class)
          klass = Class.new(object_klass, &block)
        else
          # interfaces are modules
          klass = Module.new
          klass.include(object_klass)
          klass.module_eval(&block)
          unless klass.graphql_name
            klass.graphql_name type.to_s.camelize
          end
        end

        begin
          klass.graphql_name
        rescue  NotImplementedError, ::GraphQL::RequiredImplementationMissingError
          klass.graphql_name(type.to_s.camelize)
        end

        ::Stardust::GraphQL::Types.const_set("#{type.to_s.camelize}", klass)
        @@__types__[type] = "Stardust::GraphQL::Types::#{type.to_s.camelize}".constantize
      end

      def self.clear_definitions!

        @@__defined_types__.each do |type|
          Stardust::GraphQL::Types.send(:remove_const, type)
        end

        @@__defined_types__ = []
        @@__lookedup_types__ = []
        @@__types__ = {}.merge(FIXED_TYPES)
        @@__queries__ = {}
        @@__mutations__ = {}
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

      def self.mutations
        @@__mutations__
      end

      def self.lookup_type(type)
        # puts "looking up #{type.class}: #{type}"

        if type.is_a?(Array)
          rest = type[1..-1]
          type = type.first
          is_a_array = true
        end

        raise MissingType, type.to_s unless @@__types__[type]

        @@__lookedup_types__ << type
        @@__lookedup_types__ = @@__lookedup_types__.uniq


        if is_a_array
          [@@__types__[type]] + rest
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

        ## Here we define a new graphql type
        if Stardust::GraphQL.const_defined?("Schema")
          Stardust::GraphQL.send(:remove_const, "Schema")
        end

        klass = Class.new(::GraphQL::Schema) do
          include ::Stardust::GraphQL::Federated
          use ApolloFederation::Tracing
          use ::GraphQL::Batch

        end
        Stardust::GraphQL.const_set("Schema", klass)


        # a lot of this is extracted from apollo federation gem
        # to be used in stardust
        query_class = Class.new(::Stardust::GraphQL::Object) do
          graphql_name 'Query'

          include ApolloFederation::EntitiesField
          include ApolloFederation::ServiceField
        end

        possible_entities =
          @@__types__
          .values
          .select{|i| i < Stardust::GraphQL::Object}
          .map(&:to_graphql).select do |type|
            !type.introspection? && !type.default_scalar? &&
            type.metadata[:federation_directives]&.any? { |directive|
              directive[:name] == 'key'
            }
          end

        if !possible_entities.empty?
          entity_type = Class.new(ApolloFederation::Entity) do
            possible_types(*possible_entities)
          end

          @@__types__[:_frederated_entities] = entity_type

          query_class.field(:_entities, [:_frederated_entities, null: true], null: false) do
            argument :representations, [:any], required: true
          end
        end

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
        Stardust::GraphQL::Schema.query(query_class)


        mutation_class = Class.new(::GraphQL::Schema::Object)
        mutation_class.graphql_name("Mutation")
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
        Stardust::GraphQL::Schema.mutation(mutation_class)

        #
        # orphaned_types =
        #   @@__types__
        #   .select{|k,v|
        #     !k.in?(@@__lookedup_types__) &&
        #     v < Stardust::GraphQL::Object
        #   }
        #   .values
        #   .map(&:to_graphql)
        #
        # Stardust::GraphQL::Schema.orphan_types orphaned_types
      end
    end
  end
end
