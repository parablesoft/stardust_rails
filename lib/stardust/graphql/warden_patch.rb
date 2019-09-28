module Stardust
  module GraphQL
    module WardenPatch

      private

      # Basically since we want to see
      # federated fields we want to included orphan_types
      def referenced?(type_defn)
        super || @schema.orphan_types.include?(type_defn)
      end
    end
  end
end

::GraphQL::Schema::Warden.prepend Stardust::GraphQL::WardenPatch
