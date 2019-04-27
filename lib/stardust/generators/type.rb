require 'rails/generators'

module Stardust
  module Generators
    class Type < Rails::Generators::Base

      argument :path, type: :string

      source_root File.expand_path('../../generators', __dir__)

      def generate_type
        template "type.template", "app/graph/types/#{path.underscore}.rb"
      end

      private

      def type_name
        path.underscore.split("/").last
      end
    end
  end
end
