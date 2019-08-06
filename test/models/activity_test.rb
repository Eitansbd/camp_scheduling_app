ENV["RACK_ENV"] = 'test'

require 'minitest/autorun'
require_relative '../../app/models/activity.rb'

class ActivityTest < MiniTest::Test
  setup do
    @activity = Activity.new("Activity", "Location")
  end
  
  def test_name
    assert_equal "Activity", @activity.name
  end
  
  def test_location
    assert_equal "Location", @activity.location
  end
  
  def test_set_activity_parameters
    @activity.set_activity_parameters(2, "Hey", "Daled", "t)
    
    assert_equal
  end
  
  def test_for_division?
    activity = Activity.new("Activity", "Location")

  end
end