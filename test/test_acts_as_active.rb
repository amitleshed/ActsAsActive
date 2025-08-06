# test/acts_as_active_test.rb
require_relative "test_helper"

class ActsAsActiveTest < Minitest::Test
  def setup
    Activity.delete_all
    Note.delete_all
  end

  def test_active_today_returns_true_if_activity_exists
    note = Note.create!(title: "Test note")
    note.record_activity!
    assert note.active_today?
  end

  def test_active_today_returns_false_if_no_activity
    note = Note.create!(title: "Test note")
    refute note.active_on?((Time.now - 1.day).to_date)
  end
end
