require 'rails/generators'

module Stardust
  module Generators
    class Example < Rails::Generators::Base

      source_root File.expand_path('../../generators/example', __dir__)

      def copy_initializer_file
        copy_file 'mutations/update_item.rb', 'app/graph/mutations/update_item.rb'
        copy_file 'queries/foo.rb', 'app/graph/queries/foo.rb'
        copy_file 'queries/foos.rb', 'app/graph/queries/foos.rb'
        copy_file 'types/item.rb', 'app/graph/types/item.rb'
      end
    end
  end
end
