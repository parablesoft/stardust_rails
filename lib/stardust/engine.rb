require 'stardust/email/interceptor'

module Stardust
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir["#{config.root}/app/**/"]
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    DIRS = [
      "app/graph/types",
      "app/graph/queries",
      "app/graph/mutations",
    ].freeze

    config.to_prepare do

      if Stardust.instance == :staging
        ActionMailer::Base.register_interceptor( Stardust::Email::Interceptor )
      end

      DIRS.each do |dir|
        Dir[Rails.root.join(dir).join("**/*.rb")].each do |file|
          require file
        end
      end

      Stardust::GraphQL::Collector.replace_types!

      ActiveSupport::Reloader.to_run do
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
