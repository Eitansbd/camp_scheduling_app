require 'pry'

require_relative 'controllers_helper.rb'
require_relative '../../app/controllers/bunks_controller.rb'
require_relative '../../app/models/bunk.rb'

class BunksControllerTest < ControllerTest

  def app
    BunksController
  end

  def sample_bunk
    @@database.all_bunks.sample
  end

  def test_all_bunks_page
    get '/bunks'

    assert_equal 200, last_response.status
    assert_includes last_response.body, '<a href="/bunks/new">Add New Bunk'
    assert_includes last_response.body, "<th>Name</th>"
  end

  def test_create_new_bunk_page
    get '/bunks/new'

    assert_equal 200, last_response.status
    assert_includes last_response.body, "Bunk Name:"
    assert_includes last_response.body, "Bunk Division:"
    assert_includes last_response.body, "Gender"
  end

  def test_create_new_bunk
    post '/bunks/new', name: 'testbunk', division: 'Hey', gender: 'M'

    assert_equal 302, last_response.status

    get last_response["location"]

    assert_equal 200, last_response.status
    assert_includes last_response.body, "testbunk successfully added to the database"
    assert_includes last_response.body, "testbunk</td>"
  end

  def test_create_new_bunk_name_already_exists_error
    bunk = Bunk.new('bunkdup', 'Hey', 'M')
    @@database.add_bunk(bunk)

    post '/bunks/new', name: 'bunkdup', division: 'Hey', gender: 'M'

    assert_equal 403, last_response.status
    assert_includes last_response.body, "bunk names must be unique"
    assert_includes last_response.body, "bunkdup"
  end

  def test_bunk_info_page
    bunk = sample_bunk
    @@database.populate_bunk_activity_history(bunk)
    get "/bunks/#{bunk.id}/info"

    assert_equal 200, last_response.status
    assert_includes last_response.body, "Name: #{bunk.name}"
  end

  def test_bunk_edit_page
    bunk = sample_bunk

    get "/bunks/#{bunk.id}/edit"

    assert_equal 200, last_response.status
    assert_includes last_response.body, "#{bunk.name}"
    assert_includes last_response.body, "#{bunk.division}"
    assert_includes last_response.body, "Save Changes"
  end

  def test_edit_bunk
    old_bunk = sample_bunk

    new_name = old_bunk.name + "A"
    new_gender = old_bunk.gender == "F" ? "M" : "F"
    new_division = old_bunk.division == "Hey" ? "Aleph" : "Hey"
    bunk_info = { name: new_name, division: new_division, gender: new_gender }
    
    post "/bunks/#{old_bunk.id}/edit", bunk_info

    assert_equal 302, last_response.status

    get last_response["location"]

    assert_equal 200, last_response.status
    assert_includes last_response.body, "Successfully changed #{new_name}"
    refute_includes last_response.body, "old_bunk.name</td>"
    assert_includes last_response.body, "#{new_name}</td>"
  end

  def test_delete_bunk
    bunk = sample_bunk

    post "/bunks/#{bunk.id}/delete"

    assert_equal 302, last_response.status

    get last_response["location"]

    assert_equal 200, last_response.status
    assert_includes last_response.body, "Bunk has been deleted"
    refute_includes last_response.body, "#{bunk.name}</td>"
  end

  def teardown
    super
  end
end