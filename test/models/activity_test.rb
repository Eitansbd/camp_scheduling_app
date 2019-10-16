ENV["RACK_ENV"] = 'test'

require 'minitest/autorun'
require_relative '../../app/models/activity.rb'

class ActivityTest < MiniTest::Test

  def setup
    @activity = Activity.new("Activity", "Location")
  end

  def test_name
    assert_equal "Activity", @activity.name
  end

  def test_location
    assert_equal "Location", @activity.location
  end

  def test_set_activity_parameters
    method_return = @activity.set_activity_parameters(2, "Hey", "Daled", "t")

    assert_equal 2, @activity.max_bunks
    assert_equal "Hey", @activity.youngest_division
    assert_equal "Daled", @activity.oldest_division
    assert_equal true, @activity.double
    assert_equal @activity, method_return
  end

  def test_for_division?
    activity = Activity.new("Activity", "Location")
  end

  def test_equal_same_name
    activity1 = @activity
    activity2 = Activity.new("Activity", "Other Location")

    assert_equal true, activity1 == activity2
  end
end