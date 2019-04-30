# Stardust
Short description and motivation.

## Usage
How to use my plugin.

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
end

View GraphiQL here:
[http://localhost:3000/graphiql](http://localhost:3000/graphiql)


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
