Stardust::GraphQL.define_mutation :add_item do

 description "Add a new item"
 null false

 argument :name, :string, required: true

 field :item, :item, null: true
 field :success, :boolean, null: false

 def resolve(name:)
   {
     success: true,
     item: {
       id: 4,
       name: name
     }
   }
 end


end
