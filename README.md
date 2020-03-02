# Auto Ria Api

This gem provides integration with [https://auto.ria.com/](https://auto.ria.com/)

#### Please NOTE that this is very early version and not all endpoints are implemented.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'auto_ria_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install auto_ria_api

## Usage
First of all you need an api_key which you can get at [https://developers.ria.com](https://developers.ria.com)
```ruby
# create an instance 
@client = AutoRiaApi::Base.new(api_key: ENV['AUTO_RIA_API_KEY'])

# Methods:
@client.types
@client.carcasses(type:, options: { grouped: false, all: false })
@client.marks(type:)
@client.models(type:, mark, options: { grouped: false, all: false })
@client.regions
@client.cities(region:)
@client.gearboxes(type:)
@client.fuels
@client.colors
@client.options(type:)

@client.info(car_id:)
# all method arguments assuming ID (Integer)

```
For more detailed documentation follows: 

[https://github.com/ria-com/auto-ria-rest-api/tree/master/AUTO_RIA_API](https://github.com/ria-com/auto-ria-rest-api/tree/master/AUTO_RIA_API)

[https://api-docs-v2.readthedocs.io/ru/latest/auto_ria/index.html](https://api-docs-v2.readthedocs.io/ru/latest/auto_ria/index.html)

## TODO:
1. Get rid of ::Base namespace. I.e instance should be created directly with `AutoRiaApi.new` 
1. Implement `search` 
1. Implement `average_price` 
1. Implement `info`  endpoints

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/drkmen/auto_ria_api. 
Help is appreciated Feel free to fork and make a difference!

## Tests

run `rspec` 

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
