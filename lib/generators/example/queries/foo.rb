Stardust::GraphQL.define_query :item do

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

  description "Get a specific item"
  type :item
  null true

  argument :id, :integer, required: true

  def resolve(id:)
    items.select{|i| i[:id] == id}.first
  end


end
