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

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
