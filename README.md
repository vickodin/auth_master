# AuthMaster
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "auth_master"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install auth_master
```

Install database migrations:
```bash
$ bin/rails auth_master:install:migrations
```

Run migrations:
```bash
$ bin/rails db:migrate
```

## Contributing

Build gem:
```bash
$ rake build
```

Push to RubyGems.org:
```bash
$ gem push auth_master-x.y.z.gem
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
