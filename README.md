# Wowza

Ruby wrapper around the Wowza REST API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wowza'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wowza

## Usage

**Note: the server has to have the API enabled (in config/Server.xml) and the port (default 8087) allowed.**

Create server:

```ruby
server = Wowza::REST::Server.new(host: 'example.com', port: 8087, server: 'live')
```

Connect as client:

```ruby
client = server.connect(username: 'foo', password: 'bar')
```

List of all publishers:

```ruby
publishers = client.publishers.all
```

Update a publisher:

```ruby
publisher = publishers.first
publisher.name = 'otherName'
publisher.save
```

Create a publisher

```ruby
publisher = Wowza::REST::Publisher.new(name: 'channel', password: '321')
publisher.conn = client.connection
publisher.save
```

## Development

Run `ruby bin/console` to connect to a development server.

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hashrocket/wowza. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
