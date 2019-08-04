ENV["RACK_ENV"] = "test"

require 'minitest/autorun'
require 'rack/test'

require_relative '../../app/controllers/bunks_controller.rb'
require_relative '../../app/models/bunk.rb'
require_relative '../../app/models/schedule_database.rb'


class SchedulerTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    BunksController
  end

  def test_create_new_bunk_form
    get '/bunks/new'

    assert_equal 200, last_response.status
    assert_includes last_response.body, "Bunk Name:"
    assert_includes last_response.body, "Bunk Division:"
    assert_includes last_response.body, "Gender"
  end

  def test_create_new_bunk
    post "/bunks/new", name: 'Test', division: 'Daled', gender: 'M'
  end
end