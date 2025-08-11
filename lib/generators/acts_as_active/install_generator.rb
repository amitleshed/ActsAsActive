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
        create_file "app/models/acts_as_active/activity.rb", <<~RUBY
          module ActsAsActive
            class Activity < ApplicationRecord
              self.table_name = "acts_as_active_activities"

              belongs_to :trackable, polymorphic: true
              belongs_to :actor, polymorphic: true, optional: true
            end
          end
        RUBY
      end
    end
  end
end
