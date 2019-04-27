Stardust::GraphQL.define_types do

  object :item do
    description "An example item"
    field :id, :id, null: false
    field :name, :string, null: false
  end

end
