# test/acts_as_active_test.rb
require_relative "test_helper"

class ActsAsActiveTest < Minitest::Test
  def setup
    Activity.delete_all
    Note.delete_all
    hash_setup
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

  def test_activity_count_within_date_range
    range = (1.day.ago.to_date)..(Time.current.to_date)
  
    note = Note.create!(title: "Initial Note")
    assert_equal 1, note.activity_count(range: range), "Should record 1 activity after creation"
  
    note.update!(title: "Updated Note")
    assert_equal 2, note.activity_count(range: range), "Should record 2 activities after update"
  
    another_note = Note.create!(title: "Another Note")
    assert_equal 1, another_note.activity_count(range: range), "New note should have 1 activity in range"
  end

  def hash_setup
    @note = Note.create!(title: "Test Note")

    @note.activities.create!(occurred_on: Date.new(2025, 8, 1), count: 1)
    @note.activities.create!(occurred_on: Date.new(2025, 8, 2), count: 3)
    @note.activities.create!(occurred_on: Date.new(2025, 8, 3), count: 2)
  end

  def test_heatmap_returns_correct_counts
    range = Date.new(2025, 8, 1)..Date.new(2025, 8, 3)

    expected = {
      "2025-08-01" => 1,
      "2025-08-02" => 3,
      "2025-08-03" => 2
    }

    assert_equal expected, @note.heatmap(range: range)
  end

  def test_heatmap_ignores_out_of_range_dates
    range = Date.new(2025, 8, 2)..Date.new(2025, 8, 3)

    expected = {
      "2025-08-02" => 3,
      "2025-08-03" => 2
    }

    assert_equal expected, @note.heatmap(range: range)
  end

  def test_heatmap_returns_empty_hash_if_no_activities
    range = Date.new(2025, 1, 1)..Date.new(2025, 1, 10)

    assert_equal({}, @note.heatmap(range: range))
  end
end
