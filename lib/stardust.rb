require "rails"
require "stardust/engine"
require "stardust/instance"

# this allows us to
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "GraphQL"
  inflect.acronym "DSL"
end

module Stardust
  extend Instance
end

require "stardust/graphql"
