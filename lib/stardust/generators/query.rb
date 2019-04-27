require 'rails/generators'

module Stardust
  module Generators
    class Query < Rails::Generators::Base

      argument :path, type: :string

      source_root File.expand_path('../../generators', __dir__)

      def generate_type
        template "query.template", "app/graph/queries/#{path.underscore}.rb"
      end

      private

      def type_name
        path.underscore.gsub("/", "_")
      end
    end
  end
end
