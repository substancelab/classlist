# Classlist

Serverside manipulation of CSS class lists. Works especially well with Tailwind and View Components.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'classlist'
# or if you don't want to manually require stuff:
gem 'classlist', require: 'classlist/all'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install classlist

## Usage

Imagine having a component that outputs the following markup when you render it:

```erb
<%= render(CardComponent.new) %>
```

```html
<div class="card float-left">...</div>
```

Now you're tasked with implementing a card with another background color. That's easy, you think, I'll just add an option that adds more classes to the component:

```erb
<%= render(CardComponent.new(:classes => "bg-grey")) %>
<!-- card.html.erb -->
<div class="card float-left <%= classes %>">
```

That works and all is well. But next day the task is to make a card that isn't floated left. You could remove `float-left` from the template and move it to all calls to render:

```erb
<%= render(CardComponent.new(:classes => "float-left bg-grey")) %>
<!-- card.html.erb -->
<div class="card <%= classes %>">
```

Depending on the number of classes and the number of render calls that could work. But how about if you were able to write

```erb
<%= render(CardComponent.new(:classes => Classlist::Remove.new("float-left"))) %>
```

With Classlist you can:

```ruby
# card_component.rb
def classes
  Classlist.new("card float-left") + @classes
end
```

```erb
<!-- card.html.erb -->
<div class="<%= classes %>">
```

The resulting markup will be

```html
<div class="card">
```

because

```ruby
Classlist.new("card float-left") + Classlist::Remove.new("float-left") == Classlist.new("card")
```

### Basic usage

```ruby
# Create a new classlist - these are equivalent:
classes = Classlist.new("pt-6 space-y-4")
classes = Classlist.new(["pt-6", "space-y-4"])

# Add classes
classes.add("md:p-8 text-center")
classes.to_s #=> "pt-6 space-y-4 md:p-8 text-center"

# Remove classes
classes.remove("md:p-8")
classes.to_s #=> "pt-6 space-y-4 text-center"

# Toggle classes
classes.toggle("hidden")
classes.to_s #=> "pt-6 space-y-4 text-center hidden"
classes.toggle("text-center")
classes.to_s #=> "pt-6 space-y-4 hidden"

# Replace classes
classes.replace("hidden", "block")
classes.to_s #=> "pt-6 space-y-4 block"
```

## DOM compatibility

While Classlist aims to be a feature-compatible version of [`DOMTokenList`](https://developer.mozilla.org/en-US/docs/Web/API/DOMTokenList) that doesn't always make for particularily Ruby'esque methods. In cases where Ruby has similar methods named differently than the DOM, we'll prefer Ruby-style method names while keeping aliases with the names from `DOMTokenList`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/substancelab/classlist.
