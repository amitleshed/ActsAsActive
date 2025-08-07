# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "acts_as_active"
require "minitest/autorun"
require "active_record"
require "logger"
require_relative "../lib/acts_as_active/concern"

ActiveRecord::Base.include ActsAsActive
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.logger = Logger.new(nil)

ActiveRecord::Schema.define do
  create_table :activities, force: true do |t|
    t.string  :trackable_type, null: false
    t.integer :trackable_id,   null: false
    t.date    :occurred_on,    null: false
    t.integer :count,          default: 0, null: false
    t.timestamps
  end
  add_index :activities, [:trackable_type, :trackable_id, :occurred_on], unique: true

  create_table :notes, force: true do |t|
    t.string :title
    t.timestamps
  end
end

class Activity < ActiveRecord::Base
  belongs_to :trackable, polymorphic: true
end

class Note < ActiveRecord::Base
  acts_as_active
end
