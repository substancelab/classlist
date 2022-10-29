# Classlist

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/classlist`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'classlist'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install classlist

## Usage

TODO: Write usage instructions here

## DOM compatibility

While Classlist aims to be a feature-compatible version of [`DOMTokenList`](https://developer.mozilla.org/en-US/docs/Web/API/DOMTokenList) that doesn't always make for particularily Ruby'esque methods. In cases where Ruby has similar methods named differently than the DOM, we'll prefer Ruby-style method names while keeping aliases with the names from `DOMTokenList`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/substancelab/classlist.
