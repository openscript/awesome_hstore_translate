# Awesome Hstore Translate
[![Gem Version](https://badge.fury.io/rb/awesome_hstore_translate.svg)](https://badge.fury.io/rb/awesome_hstore_translate)

This gem uses PostgreSQLs hstore datatype and ActiveRecord models to translate model data. It is based on the gem
[`hstore_translate`](https://github.com/Leadformance/hstore_translate) by Rob Worely.

 - It's ready for Rails 5
 - No extra columns or tables needed to operate
 - Clean naming in the database model
 - Everything is well tested

## Features
 - [x] `v0.1.0` Attributes override / Raw attributes
 - [x] `v0.1.0` Fallbacks
 - [x] `v0.1.0` Language specific accessors
 - [x] `v0.2.0` Awesome Hstore Translate as drop in replace for [`hstore_translate`](https://github.com/Leadformance/hstore_translate)
   - `with_[attr]_translation(str)` is not supported
 - [x] `v0.2.2` Support record selection via ActiveRecord (e. g. `where`, `find_by`, ..)
 - [x] `v0.3.0` Support record ordering via ActiveRecord `order`
 - [ ] `backlog` Support `friendly_id` (see `friendly_id-awesome_hstore` gem)

## Requirements
 - ActiveRecord `>= 5`
   - Please use [`hstore_translate`](https://github.com/Leadformance/hstore_translate), if you are on an older version.
 - I18n

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'awesome_hstore_translate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install awesome_hstore_translate

## Usage
Use `translates` in your models, to define the attributes, which should be translateable:
```ruby
class Page < ActiveRecord::Base
  translates :title, :content
end
```
Make sure that the datatype of this columns is `hstore`:
```ruby
class CreatePages < ActiveRecord::Migration
  def change
    # Make sure you enable the hstore extenion
    enable_extension 'hstore' unless extension_enabled?('hstore')

    create_table :pages do |t|
      t.column :title, :hstore
      t.column :content, :hstore
      t.timestamps
    end
  end
end
```

Use the model attributes per locale:
```ruby
p = Page.first

I18n.locale = :en
p.title # => English title

I18n.locale = :de
p.title # => Deutscher Titel

I18n.with_locale :en do
  p.title # => English title
end
```

The raw data is available via the suffix `_raw`:
```ruby
p = Page.new(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'})

p.title_raw # => {'en' => 'English title', 'de' => 'Deutscher Titel'}
```

Translated attributes:
```ruby
Page.translated_attribute_names # [:title]
```

### Fallbacks
It's possible to fall back to another language, if there is no or an empty value for the primary language. To enable fallbacks you can set `I18n.fallbacks` to `true` or enable it manually in the model:
```ruby
class Page < ActiveRecord::Base
  translates :title, :content, fallbacks: true
end
```

Set `I18n.default_locale` or `I18n.fallbacks` to define the fallback:
```ruby
I18n.fallbacks.map(:en => :de) # => if :en is nil or empty, it will use :de

p = Page.new(:title_raw => {'de' => 'Deutscher Titel'})

I18n.with_locale :en do
  p.title # => Deutscher Titel
end
```

It's possible to activate (`with_fallbacks`) or deactivate (`without_fallbacks`) fallbacks for a block execution:
```ruby
p = PageWithoutFallbacks.new(:title_raw => {'de' => 'Deutscher Titel'})

I18n.with_locale(:en) do
  PageWithoutFallbacks.with_fallbacks do
    assert_equal('Deutscher Titel', p.title)
  end
end
```

### Accessors
Convenience accessors can be enabled via the model descriptor:
```ruby
class Page < ActiveRecord::Base
  translates :title, :content, accessors: [:de, :en]
end
```

It's also make sense to activate the accessors for all available locales:
```ruby
class Page < ActiveRecord::Base
  translates :title, :content, accessors: I18n.available_locales
end
```

Now locale-suffixed accessors can be used:
```ruby
p = Page.create!(:title_en => 'English title', :title_de => 'Deutscher Titel')

p.title_en # => English title
p.title_de # => Deutscher Titel
```

Translated accessor attributes:
```ruby
Page.translated_accessor_names # [:title_en, :title_de]
```

### Find
`awesome_hstore_translate` patches ActiveRecord, so you can conviniently use `where` and `find_by` as you like.
```ruby
Page.create!(:title_en => 'English title', :title_de => 'Deutscher Titel')
Page.create!(:title_en => 'Another English title', :title_de => 'Noch ein Deutscher Titel')

Page.where(title: 'Another English title')  # => Page with title 'Another English title'
```

### Order
`awesome_hstore_translate` patches ActiveRecord, so you can conviniently use `order` as you like.

```ruby
Page.create!(:title_en => 'English title', :title_de => 'Deutscher Titel')
Page.create!(:title_en => 'Another English title', :title_de => 'Noch ein Deutscher Titel')

Page.all.order(title: :desc)  # => Page with title 'English title'
```

### Limitations
`awesome_hstore_translate` patches ActiveRecord, which create the limitation, that a with `where` chained `first_or_create` and `first_or_create!` **doesn't work** as expected.
Here is an example, which **won't** work:

``` ruby
Page.where(title: 'Titre français').first_or_create!
```

A workaround is:

``` ruby
Page.where(title: 'Titre français').first_or_create!(title: 'Titre français')
```

The where clause is internally rewritten to `WHERE 'Titre français' = any(avals(title))`, so the `title: 'Titre français'` is not bound to the scope.

### Upgrade from [`hstore_translate`](https://github.com/Leadformance/hstore_translate)
1. Replace the [`hstore_translate`](https://github.com/Leadformance/hstore_translate) with `awesome_hstore_translate` in your Gemfile
1. Activate accessors, if you used the [`hstore_translate`](https://github.com/Leadformance/hstore_translate) accessors
1. Replace `with_[attr]_translation(str)` with equivalents (see "Support record selection via ActiveRecord" feature)

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
Bug reports and pull requests are welcome on [GitHub](https://github.com/openscript/awesome_hstore_translate). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
