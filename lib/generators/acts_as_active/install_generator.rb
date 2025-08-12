require "rails/generators"
require "rails/generators/migration"

module ActsAsActive
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Generates the migration for ActsAsActive"
      include Rails::Generators::Migration

      class_option :metadata, type: :string, default: "auto", desc: "jsonb|json|none|auto"
      source_root File.expand_path("templates", __dir__)

      def self.next_migration_number(dirname)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def copy_migration
        @metadata_choice = normalize_metadata_choice(options[:metadata])
        puts "!!! metadata_choice #{@metadata_choice}"
        @adapter_name    = (ActiveRecord::Base.connection.adapter_name rescue "Unknown")
        migration_template "create_acts_as_active_activities.rb.erb", "db/migrate/create_acts_as_active_activities.rb"
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

      private

      def normalize_metadata_choice(choice)
        case choice&.downcase
        when "jsonb", "json", "none" then choice.downcase
        else "auto"
        end
      end
    end
  end
end
