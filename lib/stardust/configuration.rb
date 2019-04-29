module Stardust
  class Configuration

    def graphql
      @graphql ||= GraphQL::Configuration.new
    end

    def configure_graphql
      yield graphql
    end

  end
end
