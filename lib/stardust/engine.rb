require "graphql/rails_logger"
require 'apollo_upload_server/middleware'

class Stardust::Engine < ::Rails::Engine

    DIRS = [
      "app/graph/types",
      "app/graph/queries",
      "app/graph/mutations",
    ].freeze

    initializer "stardust.graph.draw" do |app|

      # !!IMPORTANT without this here the logger gets fired before the upload middlware
      app.middleware.use ApolloUploadServer::Middleware

      # Load graph definitions
      DIRS.each do |dir|
        Dir[Rails.root.join(dir).join("**/*.rb")].each do |file|
          require file
        end
      end
      Stardust::GraphQL::Collector.replace_types!

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

    config.to_prepare do
      # Setup logger
      ::GraphQL::RailsLogger.configure do |config|
        config.white_list = {
          'Stardust::GraphQLController' => %w(execute)
        }
      end
    end
end
