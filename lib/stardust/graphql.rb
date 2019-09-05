require "graphql"
require "graphiql/rails"
require "graphql/rails_logger"
require "graphql/batch"

require "stardust/graphql/types"

require "stardust/graphql/dsl"
require "stardust/graphql/types/dsl"

module Stardust
  module GraphQL
    extend DSL

    class MissingType < StandardError; end
  end
end

require "stardust/graphql/collector"
require "stardust/graphql/configuration"
require "stardust/graphql/field"
require "stardust/graphql/input_object"
require "stardust/graphql/mutation"
require "stardust/graphql/interface"
require "stardust/graphql/object"
require "stardust/graphql/query"
require "stardust/graphql/scalar"
require "stardust/graphql/union"
require "stardust/graphql/extensions/authorize"
require "stardust/graphql/input_object"
