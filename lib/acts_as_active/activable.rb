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
      has_many :activities, as: :trackable, class_name: "ActsAsActive::Activity"

      events      = Array(options[:on] || SUPPORTED_EVENTS) & SUPPORTED_EVENTS
      events.each do |ev|
        after_commit on: ev do |_ignored|
          should_run = true
          should_run &&=  instance_exec(&options[:if])     if options[:if]
          should_run &&= !instance_exec(&options[:unless]) if options[:unless]

          record_activity! if should_run
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
    dates = activities.pluck(:occurred_on).uniq.sort
    return 0 if dates.empty?
  
    longest = current = 1
    dates.each_cons(2) do |current_date, next_date|
      if next_date == current_date + 1
        current += 1
        longest = current if current > longest
      else
        current = 1
      end
    end

    longest
  end
  
  def current_streak
    date_set = activities.pluck(:occurred_on).to_set
    count    = 0
    day      = Date.today
  
    while date_set.include?(day)
      count += 1
      day   -= 1
    end
  
    count
  end 
end