require_relative 'controllers_helper.rb'
require_relative '../../app/controllers/activities_controller.rb'
require_relative '../../app/models/activity.rb'

class ActivitiesControllerTest < ControllerTest
  def app
    ActivitiesController
  end

  def sample_activity
    @@database.all_activities.sample
  end

  def test_all_activities_page
    get '/activities'

    assert_equal 200, last_response.status
    assert_includes last_response.body, '<a href="activities/new">Add New Acivity'
    assert_includes last_response.body, "<th>Name</th>"
    assert_includes last_response.body, '<table class="activities-table">'
  end

  def test_create_new_activity_page
    get '/activities/new'

    assert_equal 200, last_response.status
    assert_includes last_response.body, '<form action="/activities/new"'
    assert_includes last_response.body, 'Add Activity'
  end

  def test_create_new_activity
    act_info = {name: 'actname', location: 'Field', youngest_division: 'Hey',
                oldest_division: 'Daled', max_bunks: 2, double: 'true'}

    post('/activities/new', act_info)

    assert_equal 302, last_response.status

    get last_response["location"]

    assert_equal 200, last_response.status

    assert_includes last_response.body, "actname successfully added to the database"
    assert_includes last_response.body, "actname</td>"
  end

  def test_edit_activity_page
    activity = sample_activity

    get "/activities/#{activity.id}/edit"

    assert_equal 200, last_response.status

    assert_includes last_response.body, "#{activity.name}"
    assert_includes last_response.body, "#{activity.location}"
  end

  def test_delete_activity
    activity = sample_activity

    post "/activities/#{activity.id}/delete"

    assert_equal 302, last_response.status

    get last_response["location"]

    assert_equal 200, last_response.status
    assert_includes last_response.body, "Activity has been deleted"
    refute_includes last_response.body, "/activities/#{activity.id}/edit"
  end
end