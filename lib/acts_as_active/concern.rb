module ActsAsActive
  extend ActiveSupport::Concern

  class_methods do
    def acts_as_active(options = {})
      has_many :activities, as: :trackable, class_name: "Activity"
      events = Array(options[:on] || [:create, :update, :destroy])
      supported = %i[create update destroy]
      
      events.each do |event|
        next unless supported.include?(event)
        after_commit -> { record_activity(event) }, on: event
      end
    end
  end

  private

  def record_activity(event)
    Rails.logger.info "[ActsAsActive] Recorded #{event} for #{self.inspect}"
    self.activities.create(occurred_on: Time.now.to_date)
  end
end