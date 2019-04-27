Stardust::GraphQL.define_query :items do

  def items
    [
      {
        id: 1,
        name: "foo"
      },
      {
        id: 2,
        name: "bar"
      },
      {
        id: 3,
        name: "baz"
      }
    ].freeze
  end

  description "Get a list of items"
  type [:item]
  null false

  def resolve
    items
  end


end
