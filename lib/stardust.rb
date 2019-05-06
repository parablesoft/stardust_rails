require "stardust/instance"
require "stardust/configuration"

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "GraphQL"
  inflect.acronym "DSL"
end

module Stardust
  extend Instance

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

end

require "stardust/errors"
require "stardust/graphql"
require "stardust/generators"
require "stardust/engine"
