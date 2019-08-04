ENV["RACK_ENV"] = 'test'

require 'minitest/autorun'
require_relative '../../app/models/bunk.rb'

class BunkTets < MiniTest::Test
  def test_add_to_activity_history
    id = 1
    name = 'Bunk1'
    division = 'Division1'
    gender = 'Male'
    
    bunk = Bunk.new(name, division, gender, id)
    
    bunk.add_to_activity_history()
  end
end