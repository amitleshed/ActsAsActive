require "active_support"
require "active_support/concern"

module ActsAsActive
  extend ActiveSupport::Concern

  included do
    include InstanceMethods
  end

  class_methods do
    SUPPORTED_EVENTS = %i[create update destroy].freeze

    def acts_as_active(options = {})
      has_many :activities, as: :trackable, class_name: "Activity"

      events = Array(options[:on] || SUPPORTED_EVENTS) & SUPPORTED_EVENTS
      events.each do |ev|
        after_commit on: ev do |_ignored|
          record_activity!
        end
      end
    end
  end


  def record_activity!(at: Time.current)
    today    = at.to_date
    activity = activities.find_or_initialize_by(occurred_on: today)
  
    activity.count ||= 0
    activity.count  += 1
    activity.save!
  end
end

module InstanceMethods
  def active_today?
    self.activities.find_by(occurred_on: Time.current.to_date).present?
  end

  def active_on?(date)
    self.activities.find_by(occurred_on: date).present?
  end

  def activity_count(range:)
    self.activities.where(occurred_on: range).sum(:count)
  end
  
  def heatmap(range:)
    activity_data = activities.where(occurred_on: range).pluck(:occurred_on, :count)
  
    activity_data.each_with_object(Hash.new(0)) do |(date, count), hash|
      hash[date.to_s] = count
    end
  end

  def longest_streak
  end

  def current_streak
  end
end