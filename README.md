# Talking

Simple talking module for your programs. Don't confuse it with logging. It's not logging. It's just
the simplest possible module that allows your application to speak two kinds of messages, natural (standard) and (debug). It's easily configurable and embeddable into your stuff.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'talking'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install talking

## Usage

Give voice to your class or module:

```ruby
require 'talking'

class Person
  include Talking::Talkative
end

borat = Person.new
borat.say('Hello!')
borat.debug('This is niiiice!')
```

The outputs can be configured using either stream, null or custom voices. Here are defaults:

```ruby
Person.mouth.natural_voice = Talking::StreamVoice.new(STDERR)
Person.mouth.debug_voice = Talking::NullVoice.instance
```

Debug mode is actually automatic, whenever you provide `DEBUG` environment variable set to `1`
it will automatically set stream voice for debugging, otherwise the null one will be used. In the
end code we have something like this, so you can have an idea:

```ruby
def mouth
  @mouth ||= Mouth.new(
    StreamVoice.new(STDERR),
    ENV['DEBUG'] == '1' ? StreamVoice.new(STDERR) : NullVoice.instance
  )
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/talking.

