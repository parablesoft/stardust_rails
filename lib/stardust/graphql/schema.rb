
module Stardust
  module GraphQL
    class Schema < ::GraphQL::Schema
      use ::GraphQL::Batch
    end
  end
end
