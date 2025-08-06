require "rails/generators"
require "rails/generators/migration"

module ActsAsActive
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)
      desc "Generates the migration for ActsAsActive"

      def self.next_migration_number(dirname)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def copy_migration
        migration_template "create_activities.rb", "db/migrate/create_activities.rb"
        create_model
      end

      def create_model
        create_file "app/models/activity.rb", <<~RUBY
          class Activity < ApplicationRecord
            belongs_to :trackable, polymorphic: true, class_name: "Activity"
          end
        RUBY
      end
    end
  end
end
