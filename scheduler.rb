require 'date'
require 'pry'
require 'sinatra'
require 'tilt/erubis'
require_relative './lib/bunk_activity_calendar.rb'
require_relative './lib/schedule_database.rb'

configure(:development) do
  require 'sinatra/reloader'
  also_reload './lib/bunk_activity_calendar.rb'
  also_reload './lib/schedule_database.rb'
  enable :sessions
  set :session_secret, "secret"
end

before do
  @database = ScheduleDatabase.new(logger)
end

helpers do
  def divisions
    @database.all_divisions
  end

  def bunk_schedule_keys(bunk_schedule)
    bunk_schedule.first.keys
  end

  def bunk_schedule_data(bunk_schedule)
    bunk_schedule.map do |activity|
      [
       activity["Activity"],   activity["Location"],
       activity["Start Time"], activity["End Time"],
       activity["Time Slot"]
      ]
    end
  end

  # takes in the daily schedule and yields to a block the bunk and an array of
  # the activities the bunk has that day in order
  def all_bunks_activities(daily_schedule)
    bunks = daily_schedule.bunks

    bunks.each do |bunk|
      activities = []
      time_slot_ids = []

      daily_schedule.schedule.each do |_, (bunk_activities_hash)|
        activities << bunk_activities_hash[bunk]
      end

      yield(bunk, activities)

    end
  end

  def daily_schedule_time_slots(daily_schedule)
    ["Bunk"] + daily_schedule.time_slots
  end

  def available_activities
    @database.all_activities.each{ |activity| yield(activity.id, activity.name, activity.location) }
  end

  def available_dates
    @database.get_days_in_month.map { |day| day.values }
  end

  def date_of_schedule(daily_schedule)
    day_id = daily_schedule.day_id
    result = @database.get_date_from_day_id(day_id)
    result.values[0][0]
  end
end

get '/' do
  day_id = @database.get_todays_day_id

  if day_id
    @daily_schedule = @database.get_daily_schedule(day_id)
    erb :daily_schedule
  else
    erb "there is no schedule for today"
  end
end

get '/activities' do
  @all_activities = @database.all_activities
  erb :activities
end

get '/activities/new' do  # Works
  erb :new_activity
end

post '/activities/new' do  # Works
  # instantiates a new activity object
  activity = Activity.new(params[:name], params[:location]).set_activity_parameters(
                                                                params[:max_bunks],params[:youngest_division],
                                                                params[:oldest_division], params[:double])
  # adds the activity to the database
  @database.add_activity(activity)
  redirect '/activities'
end

get '/activities/:activity_id/edit' do
  activity_id = params[:activity_id].to_i
  @activity = @database.get_activity(activity_id)

  erb :edit_activity
end

post '/activities/:activity_id/new' do  # Works
  # instantiates a new activity object
  activity = Activity.new(params[:name], params[:location], params[:activity_id].to_i).set_activity_parameters(
                                                                params[:max_bunks].to_i,params[:youngest_division],
                                                                params[:oldest_division], params[:double])
  # adds the activity to the database
  @database.edit_activity(activity)
  redirect '/activities'
end

post '/activities/:activity_id/delete' do
  id = params[:activity_id].to_i

  @database.delete_activity(id)

  redirect '/activities'
end

get '/time_slots' do
  @all_time_slots = @database.all_time_slots
  erb :time_slots
end

get '/time_slots/:time_slot_id/edit' do
  time_slot_id = params[:time_slot_id].to_i
  @time_slot = @database.get_time_slot(time_slot_id)

  erb :edit_time_slot
end

post '/time_slots/:time_slot_id/edit' do
  time_slot_id = params[:time_slot_id]
  start_time = params[:start_time]
  end_time = params[:end_time]

  @database.edit_time_slot(time_slot_id, start_time, end_time)

  redirect '/time_slots'
end

get '/time_slots/new' do # Works
  # renders page to add new time slot
  erb :new_time_slot
end

# adds a new time slot to the database
post '/time_slots/new' do  # Works
  start_time = params[:start_time]
  end_time = params[:end_time]

  @database.add_time_slot(start_time, end_time)
  redirect '/time_slots'
end

post '/time_slots/:time_slot_id/delete' do
  id = params[:time_slot_id].to_i

  @database.delete_time_slot(id)

  redirect '/time_slots'
end

get '/calendar/new' do
  erb :new_calendar  # work in progress
end

post '/calendar/generate' do  # Need to work on this/maybe get rid of it
    start_day = '2019-08-01' # params[:start_day]
    end_day = '2019-09-01' # params[:end_day]
    month_calendar = generate_calendar(start_day, end_day)
    reidrect '/'
end

get '/divisions' do
  @all_divisions = @database.all_divisions
  erb :divisions
end

get '/divisions/:division_id/edit' do
  @division_id = params[:division_id].to_i
  @division = @database.get_division(@division_id)

  erb :edit_division
end

post '/divisions/:division_id/edit' do
  id = params[:division_id]
  name = params[:name]

  @database.edit_division(id, name)

  redirect '/divisions'
end

get '/divisions/new' do # Works
  erb :new_division
end

post '/divisions/new' do
  name, age = params[:name], params[:age]

  @database.add_division(name, age)
  redirect '/divisions'
end

post '/divisions/:division_id/delete' do
  id = params[:division_id].to_i

  @database.delete_division(id)

  redirect '/divisions'
end

get '/bunks' do
  @all_bunks = @database.all_bunks
  erb :bunks
end

get '/bunks/:bunk_id/edit' do
  id = params[:bunk_id].to_i
  @bunk = @database.load_bunk(id)
  erb :edit_bunk
end

post '/bunks/:bunk_id/edit' do
  bunk = Bunk.new(params[:name], params[:division], params[:gender], params[:bunk_id].to_i)

  @database.edit_bunk(bunk)

  redirect '/bunks'
end

get '/bunks/new' do  # Works
  # renders page to create a new bunk
  # page has form with bunk name, division, gender
  erb :new_bunk
end

post '/bunks/new' do # works
  bunk = Bunk.new(params[:name], params[:division], params[:gender])
#   creates a new bunk
#   instantiates bunk object and send it to the database
  @database.add_bunk(bunk)

  redirect '/bunks'
end

post '/bunks/:bunk_id/delete' do
  id = params[:bunk_id]

  @database.delete_bunk(id)

  redirect '/bunks'
end

get '/bunks/:bunk_id' do  # Works but could use improvement
  id = params[:bunk_id].to_i
  @bunk = @database.load_bunk(id)

  erb :bunk_page
end

get '/bunks/:bunk_id/dailyschedule/:day_id' do  # Works
  # renders page for a bunks daily schedule, including previous ones
  # retrives from database the schedule based on bunk id and day id
  bunk_id = params[:bunk_id].to_i
  day_id = params[:day_id].to_i
  @bunk = @database.load_bunk(bunk_id)
  @bunk_schedule = @database.get_bunk_schedule(bunk_id, day_id)
  erb :bunk_schedule
end

get '/bunks/:bunk_id/activities_history' do  # Works
  # renders page that displays the amount of times (and days?) that
  # a specific bunk had individual activities
  bunk_id = params[:bunk_id].to_i
  @bunk_activity_history = @database.get_bunk_activity_history(bunk_id)

  erb :bunk_activity_history
end

get '/dailyschedules/new' do

  @daily_schedule = @database.get_default_schedule

  erb :new_daily_schedule
end

post '/dailyschedules/new' do  # Needs work
  day_id = params["new_schedule_date"]

  time_slots = @database.all_time_slots
  bunks = @database.all_bunks
  activities = @database.all_activities

  @daily_schedule = DailySchedule.new(day_id, time_slots, activities, bunks)

  params.each do |key, value|
    next unless (key.match(/^\d+,\d+$/) && value != "")
    bunk_id, time_slot_id = key.split(',').map(&:to_i)
    activity_id = value.to_i
    activity = activities.find{ |activity| activity.id == activity_id }
    bunk = bunks.find { |bunk| bunk.id == bunk_id }
    @daily_schedule.schedule[time_slot_id][bunk] = activity
    # returns a hash with all of the new activities to be stored in the database
  end

  activity_history = @database.get_activity_history

  activity_history.each do |activity|
    bunk_id = activity[:bunk_id]
    date = activity[:date]
    activity_id = activity[:activity_id]
    bunk = bunks.find { |bnk| bnk.id == bunk_id }
    activity = activities.find { |act| act.id == activity_id}
    bunk.add_to_activity_history(date, activity)
  end

  @daily_schedule.schedule_all_activities

  #session[:daily_schedule] = @daily_schedule

  erb :save_daily_schedule
  # creates the daily schedule - maybe loads template for a new schedule. Fills
  # in anything that is defined by the user in the post. Then calls the schedule
  # all activities method to assign the rest of the schedule


    # still need to fill in remaining calendar
end

# get '/dailyschedule/save' do
#   @daily_schedule = session[:daily_schedule]
# end

post '/dailyschedules/save' do
  day_id = params["day_id"]

  time_slots = @database.all_time_slots
  bunks = @database.all_bunks
  activities = @database.all_activities

  @daily_schedule = DailySchedule.new(day_id, time_slots, activities, bunks)

  params.each do |key, value|
    next unless (key.match(/^\d+,\d+$/) && value != "")
    bunk_id, time_slot_id = key.split(',').map(&:to_i)
    activity_id = value.to_i
    activity = activities.find{ |act| act.id == activity_id }
    bunk = bunks.find { |bnk| bnk.id == bunk_id }
    @daily_schedule.schedule[time_slot_id][bunk] = activity
    # returns a hash with all of the new activities to be stored in the database
  end

  @database.add_daily_schedule(@daily_schedule)
end

get '/dailyschedules/:day_id' do  # Works
  # renders page of a daily schedule based on the id. Needs to load the schedule
  # from the database.
  day_id = params[:day_id].to_i

  # returns an array of all of the days activities
  @daily_schedule = @database.get_daily_schedule(day_id)

  erb :daily_schedule
end

get '/dailyschedules/:day_id/edit' do # Doesn't work
  # renders edit page for daily schedule.

end

def generate_calendar(start_day, end_day)
  date = Date.parse(start_day)
  end_date = Date.parse(end_day)
  while date <= end_date do
    @database.add_date(date.to_s)
    date = date.next
  end
end

