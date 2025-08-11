# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "acts_as_active"
require "minitest/autorun"
require "active_record"
require "active_support/testing/time_helpers"
require "logger"
require_relative "../lib/acts_as_active/activable"

class Minitest::Test
  include ActiveSupport::Testing::TimeHelpers
end

ActiveRecord::Base.include ActsAsActive
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.logger = Logger.new(nil)

ActiveRecord::Schema.define do
  create_table :acts_as_active_activities do |t|
    t.string     :trackable_type, null: false
    t.bigint     :trackable_id,   null: false
    t.references :actor, polymorphic: true, null: true
    t.date       :occurred_on,    null: false
    t.integer    :count,          null: false, default: 0

    t.timestamps
  end
  add_index :acts_as_active_activities, [:trackable_type, :trackable_id, :occurred_on], unique: true, name: "index_activities_on_trackable_and_occurred_on"

  create_table :notes, force: true do |t|
    t.string :title
    t.timestamps
  end

  create_table :conditional_notes, force: true do |t|
    t.string :title
    t.timestamps
  end
end

module ActsAsActive
  class Activity < ActiveRecord::Base
    self.table_name = "acts_as_active_activities"

    belongs_to :trackable, polymorphic: true
  end
end

class Note < ActiveRecord::Base
  acts_as_active
end

class ConditionalNote < ActiveRecord::Base
  acts_as_active on: [:create, :update],
                 if:     -> { track_activity? },
                 unless: -> { skip_tracking? }

  def track_activity?
    @track_activity != false
  end

  def skip_tracking?
    @skip_tracking == true
  end

  def track_activity=(value)
    @track_activity = value
  end

  def skip_tracking=(value)
    @skip_tracking = value
  end
end
