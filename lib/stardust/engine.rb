require 'stardust/email/interceptor'
require "graphql/rails_logger"

module Stardust
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir[
      "#{config.root}/app/**/",
      "#{config.root}/lib/**/"
    ]

    DIRS = [
      "app/graph/types",
      "app/graph/queries",
      "app/graph/mutations",
    ].freeze

    config.to_prepare do

      # Setup logger
      ::GraphQL::RailsLogger.configure do |config|
        config.white_list = {
          'Stardust::GraphQLController' => %w(execute)
        }
      end

      # Handle email interceptor
      if Stardust.instance == :staging
        ActionMailer::Base.register_interceptor( Stardust::Email::Interceptor )
      end


      # Load graph definitions
      DIRS.each do |dir|
        Dir[Rails.root.join(dir).join("**/*.rb")].each do |file|
          require file
        end
      end
      Stardust::GraphQL::Collector.replace_types!


      # Reload graph definitions with "reload!" in development
      ActiveSupport::Reloader.after_class_unload do
        Stardust::GraphQL::Collector.clear_definitions!
        DIRS.each do |dir|
          Dir[Rails.root.join(dir).join("**/*.rb")].each do |file|
            load file
          end
        end
        Stardust::GraphQL::Collector.replace_types!
      end

    end
  end
end
