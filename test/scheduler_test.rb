require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/reporters'
require 'date'

Minitest::Reporters.use!

require_relative '../scheduler'

class SchedulerTest < MiniTest::Test
  include Rack::Test::Methods
  
  def setup
    
  end
end