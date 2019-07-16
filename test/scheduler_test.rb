require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/reporters'
require 'date'

Minitest::Reporters.use!

require_relative '../scheduler'

ENV["RACK_ENV"] = "test"

class SchedulerTest < MiniTest::Test
  include Rack::Test::Methods

  def setup

  end

  def teardown
    query("TRUNCATE TABLE scheduler, days, time_slots, default_schedule, activities, bunks, divisions;")
    query("ALTER SEQUENCE activities_id_seq RESTART;")
    query("ALTER SEQUENCE bunks_id_seq RESTART;")
    query("ALTER SEQUENCE days_id_seq RESTART;")
    query("ALTER SEQUENCE default_schedule_id_seq RESTART;")
    query("ALTER SEQUENCE divisions_id_seq RESTART;")
    query("ALTER SEQUENCE time_slot_id_seq RESTART;")
  end
end