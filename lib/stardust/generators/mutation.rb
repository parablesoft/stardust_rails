require 'rails/generators'

module Stardust
  module Generators
    class Mutation < Rails::Generators::Base

      argument :path, type: :string

      source_root File.expand_path('../../generators', __dir__)

      def generate_type
        template "mutation.template", "app/graph/mutations/#{path.underscore}.rb"
      end

      private

      def type_name
        path.underscore.gsub("/", "_")
      end
    end
  end
end
