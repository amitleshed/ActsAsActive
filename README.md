# ActsAsActive

Acts As Active adds plug-and-play activity tracking to any ActiveRecord model, giving you instant daily stats, streak analytics, and heatmap-ready data.

It works by automatically establishing a polymorphic association with your model and generating an Activity record for each specified lifecycle event.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add acts_as_active
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install acts_as_active
```

## Usage

```ruby
class Record < ApplicationRecord
  acts_as_active on: [:create, :update],                 # ➜ Track different actions
                 if:           -> { track_activity? },   # ➜ On different conditions
                 unless:       -> { skip_tracking? },
                 after_record: -> ( activity ) { puts "Modified: #{activity}" }   # ➜ Hook: runs after an activity is created or updated
end
```

```ruby
record = Record.create!(title: "First draft")   # ➜ Records activity for today
record.update!(title: "Second draft")           # ➜ Activity count for today = 2
 

record.active_today?                # => true
record.active_on?(Date.yesterday)   # => false
record.activity_count(range: 1.day.ago..Date.today)
# => 2   (two events in the last 24 h)


record.heatmap(range: 1.week.ago..Date.today)
# => { "2025-08-01" => 1, "2025-08-02" => 3, "2025-08-03" => 2 }

record.longest_streak   # => 3   (e.g. active 1-3 Aug)
record.current_streak   # => 2   (e.g. active 5-6 Aug, still “on a streak” today)
```

## Accessing Activities

```ruby
record = Record.find(1) 
record.activities  # Accessing activities for a model that includes ActsAsActive

ActsAsActive::Activity.where(trackable: record)  # Query the namespaced model directly
ActsAsActive::Activity.all                       # Get all activities across all trackable types
```

## Run Tests

```bash
ruby -Ilib:ruby test/test_acts_as_active.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amitleshed/acts_as_active. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/amitleshed/acts_as_active/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActsAsActive project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/amitleshed/acts_as_active/blob/main/CODE_OF_CONDUCT.md).
