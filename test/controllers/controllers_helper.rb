ENV["RACK_ENV"] = "test"

require 'minitest/autorun'
require 'rack/test'

require_relative '../../app/models/schedule_database.rb'

class ControllerTest < MiniTest::Test
  include Rack::Test::Methods

  @@database = CampDatabase.new

  def session
    last_request.env["rack.session"]
  end
end