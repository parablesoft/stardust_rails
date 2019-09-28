require 'apollo-federation/federated_document_from_schema_definition.rb'

module Stardust
  module GraphQL
    module Federated
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods

        def federation_sdl
          # remove this hack once this https://github.com/apollographql/apollo-server/issues/3100 gets fixed
          @federation_sdl ||= begin
            document_from_schema = ApolloFederation::FederatedDocumentFromSchemaDefinition.new(self)
            ::GraphQL::Language::Printer.new.print(document_from_schema.document).gsub("schema {\n  query: Query\n  mutation: MutationRoot\n}\n\n", "")
          end
        end
      end
    end
  end
end
