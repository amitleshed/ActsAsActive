# frozen_string_literal: true

require_relative "lib/acts_as_active/version"

Gem::Specification.new do |spec|
  spec.name    = "acts_as_active"
  spec.version = ActsAsActive::VERSION
  spec.authors = ["Amit Leshed"]
  spec.email   = ["amitleshed@icloud.com"]

  spec.summary     = "Track activity and generate streaks, heatmaps, and visualizations for ActiveRecord models"
  spec.description = "Acts As Active is a tracker and activity generator for any ActiveRecord model, making it easy to generate statistics, streaks, and data visualization."
  spec.homepage    = "https://www.amitleshed.com"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  # spec.metadata["allowed_push_host"] = "test"
  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/amitleshed/acts_as_active"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "activesupport", ">= 7.0"
  spec.add_dependency "activerecord", ">= 7.0"
  spec.add_development_dependency "sqlite3", ">= 2.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
