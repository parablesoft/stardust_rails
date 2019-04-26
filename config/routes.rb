Rails.application.routes.draw do

  post "/graphql", to: "stardust/graphql#execute"
  if Stardust.instance == :development
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
end
