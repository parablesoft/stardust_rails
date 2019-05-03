# Stardust
GraphQL APIs in Rails made easy

Building on top of the fantastic [graphql-ruby](https://github.com/rmosolgo/graphql-ruby) gem, Stardust allows you to focus on business logic

```
- app
  - graph
    - mutations
    - queries
    - types
```

## Usage

Stardust uses `define_` hooks to automatically build out the graph by crawling through the `graph` directory inside your application.

Mutations and Queries are called through the `resolve` method. Any arguments are passed in as **named** arguments to the function.

### Mutation

Mutations are used to define

```ruby
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
```

### Query

```ruby
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
```

### Authorization


#### Initializer
To use authorization with this gem, you must set it up with an initializer to process setup the context in light of the request.

```ruby
Stardust.configure do |config|

  config.configure_graphql do |graphql|
    # Hook to setup context
    graphql.setup_context do |request|
        {
        current_user: Accounts::User::VerifyAuthorization.(request),
        ip: request.remote_ip,
        user_agent: request.headers["HTTP_USER_AGENT"],
        timezone: "Eastern Time (US & Canada)"
        }
    end
  end
end
```

In the code above there was an authorizer method to get the current user.

**Authorizer method**

```ruby
Accounts::User::VerifyAuthorization.(request)
```

This is not presently built into the stardust_rails gem. You will need to provide your own method for processing the request.

<hr/>

#### Queries and Mutations

For a query or mutation, define self.authorized?(_,ctx) on your class. Within that you may define whatever you'd like for specifying who has access to run it.

```ruby
def self.authorized?(_, ctx)
  ctx[:current_user]
end
```



### Type

```ruby
Stardust::GraphQL.define_types do

  object :item do
    description "An example item"
    field :id, :id, null: false
    field :name, :string, null: false
  end

end
```





## Installation
Add this line to your application's Gemfile:

```ruby
gem 'stardust_rails', require: 'stardust'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install stardust_rails
```

Mount the engine:
```ruby
# config/routes.rb
Rails.application.routes.draw do
  ...
  mount Stardust::Engine, at: "/"
  ...
end
```

Generate your first type, query or mutation:
```bash
$ rails g stardust:example
$ rails g stardust:type foo
$ rails g stardust:query foos
$ rails g stardust:mutation bar
```

View GraphiQL here:
[http://localhost:3000/graphiql](http://localhost:3000/graphiql)


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
