# Neoway

This gem was created to easily consume neoway API in any ruby app. The errors are still thrown from the RestClient so you need the documentation provided by them to understand what they mean.
Note that this gem only provides shortcuts.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'neoway'
```

Execute:

    $ bundle

Or install it yourself as:

    $ gem install neoway

It's important to set the variables in some config file or it'll raise an error.(In case of Rails apps, you can use application.rb or some env file.)

```ruby
Neoway.user_name = ENV['neoway_user']
Neoway.password = ENV['neoway_password']
```

## Usage

To make a PF consult just use:

```ruby
 document = "Some CPF"
 Neoway::Request.consulta_pessoa_fisica(document)
```

To make a PJ consult just use:

```ruby
 document = "Some CNPJ"
 Neoway::Request.consulta_pessoa_juridica(document)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/neoway_ruby_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Neoway project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/neoway_ruby_client/blob/master/CODE_OF_CONDUCT.md).

[USERNAME]: danfaiole