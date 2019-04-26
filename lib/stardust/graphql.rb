require "graphql"
require "graphiql/rails"
require "graphql/rails_logger"
require "graphql/batch"

require "stardust/graphql/types"
require "stardust/graphql/schema"

require "stardust/graphql/dsl"
require "stardust/graphql/types/dsl"

module Stardust
  module GraphQL
    extend DSL
  end
end

require "stardust/graphql/field"
require "stardust/graphql/object"
require "stardust/graphql/collector"
