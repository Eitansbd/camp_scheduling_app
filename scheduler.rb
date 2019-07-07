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

  def daily_schedule_time_slots(daily_schedule)
    ["Bunk"] + daily_schedule.time_slots
  end

  def daily_schedule_bunk_activity_list(daily_schedule)
    list = {}
    daily_schedule.bunks.each do |bunk|
      list[bunk] = bunk.todays_schedule.to_a
    end
    list
  end

  def available_activities
    @database.all_activities.map{ |activity| [activity.id, activity.name, activity.location] }
  end

  def available_dates
    @database.get_days_in_month.map { |day| day.values }
  end
end

get '/' do
  gender = "M"
  day_id = @database.get_todays_day_id
  time_slots = @database.all_time_slots
  activities = @database.all_activities
  bunks = @database.all_bunks(gender)  # need to add gender
  @daily_schedule = DailySchedule.new(day_id, time_slots, activities, bunks)
  @daily_schedule.schedule_all_activities
  erb :daily_schedule
end

post '/calendar_days/generate' do  # make the form for this
    start_day = '2019-08-01' # params[:start_day]
    end_day = '2019-09-01' # params[:end_day]
    month_calendar = generate_calendar(start_day, end_day)
    reidrect '/'
end

get '/activity/new' do  # Works
  erb :new_activity
end

post '/activity/new' do  # Works
  # instantiates a new activity object
  activity = Activity.new(params[:name], params[:location], params[:youngest_division], params[:oldest_division], params[:max_bunks])
  # adds the activity to the database
  @database.add_activity(activity)
  redirect '/'
end

get '/time_slot/new' do # Works
  # renders page to add new time slot
  erb :new_time_slot
end

# adds a new time slot to the database
post '/time_slot/new' do  # Works
  name = params[:name]
  start_time = params[:start_time]
  end_time = params[:end_time]

  @database.add_time_slot(name, start_time, end_time)
end

get '/calendar/new' do
  erb :new_calendar  # work in progress
end

get '/division/new' do # Works
  erb :new_division
end

post '/division/new' do
  name, age = params[:name], params[:age]

  @database.add_division(name, age)

end

get '/bunk/new' do  # Works
  # renders page to create a new bunk
  # page has form with bunk name, division, gender
  erb :new_bunk
end

post '/bunk/new' do
  bunk = Bunk.new(params[:name], params[:division], params[:gender])
#   creates a new bunk
#   instantiates bunk object and send it to the database
  @database.add_bunk(bunk)

  redirect '/'
end

get '/bunk/:bunk_id' do  # Works but could use improvement
  id = params[:bunk_id].to_i
  @bunk = @database.load_bunk(id)

  erb :bunk_page
end

get '/bunk/:bunk_id/daily_schedule/:day_id' do  # Works
  # renders page for a bunks daily schedule, including previous ones
  # retrives from database the schedule based on bunk id and day id
  bunk_id = params[:bunk_id].to_i
  day_id = params[:day_id].to_i
  @bunk = @database.load_bunk(bunk_id)
  @bunk_schedule = @database.get_bunk_schedule(bunk_id, day_id)
  erb :bunk_schedule
end

get '/bunk/:bunk_id/activities_history' do  # Works
  # renders page that displays the amount of times (and days?) that
  # a specific bunk had individual activities
  bunk_id = params[:bunk_id].to_i
  @activity_history = @database.get_bunk_activity_history(bunk_id) 

  erb :bunk_activity_history
end

get '/dailyschedule/new/:gender' do  # Works
  # renders new schedule page. Should load bunks and time slots and have a drop
  # down menu for each time slot. -- the name should be 3 digits - bunk_id, time_id
  # and day_id. Not sure how to deal with the issue that we need dyamic drop downs
  # to get rid of activities that were just chosen. Page should
  gender = params[:gender][0].upcase

  @daily_schedule = generate_empty_schedule(gender)
  erb :new_daily_schedule
end

post '/dailyschedule/new' do  # Needs work
  day_id = params.delete("new_schedule_date")
  new_schedule = params.map do |key, value|
    bunk_id, time_slot_id = key.split(',')
    activity_id = value
    {
      day_id: day_id,
      bunk_id: bunk_id,
      time_slot_id: time_slot_id,
      activity_id: activity_id
    }
    # returns a hash with all of the new activities to be stored in the database
  end

  # creates the daily schedule - maybe loads template for a new schedule. Fills
  # in anything that is defined by the user in the post. Then calls the schedule
  # all activities method to assign the rest of the schedule


    # still need to fill in remaining calendar
end

get '/dailyschedule/:day_id' do  # Works
  # renders page of a daily schedule based on the id. Needs to load the schedule
  # from the database.
  day_id = params[:day_id].to_i

  # returns an array of all of the days activities
  results = @database.get_daily_schedule(day_id)

  time_slots = collect_time_slots(results)

  bunks_unstructured = generate_list_of_bunks(results)
  bunks = restructure_bunks(bunks_unstructured)

  # returns the following format

  # [#<Bunk:0x007fc363230dd8tion>)>
  # @default_activities={},
  # @division="Hey",
  # @gender="Male",
  # @id=nil,
  # @name="B6",
  # @todays_schedule=
  #  {"11:00:00"=>
  #    #<Activity:0x007fc363231670
  #     @appropriate_divisions=["Hey", "Aleph", "Bet", "Gimmel", "Daled"],
  #     @location="NCT",
  #     @max_bunks=1,
  #     @name="Tennis",
  #     @oldest_division="Daled",
  #     @youngest_division="Hey">,
  #   "01:00:00"=>
  #    #<Activity:0x007fc363231378
  #     @appropriate_divisions=["Hey", "Aleph", "Bet", "Gimmel", "Daled"],
  #     @location="Boys Field",
  #     @max_bunks=1,
  #     @name="Softball",
  #     @oldest_division="Daled",
  #     @youngest_division="Hey">,
  #   "12:04:00"=>
  #    #<Activity:0x007fc3632310d0
  #     @appropriate_divisions=["Hey", "Aleph", "Bet", "Gimmel", "Daled"],
  #     @location="Gefen",
  #     @max_bunks=1,
  #     @name="Zumba",
  #     @oldest_division="Daled",
  #     @youngest_division="Hey" } ]

  @daily_schedule = DailySchedule.new(day_id, time_slots, nil, bunks)

  erb :daily_schedule
end

get '/dailyschedule/:day_id/edit' do # Doesn't work
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

def split_to_bunks(activities)
  time_slots = activities.map{ |activity| activity[:start_time] }
  bunks = Hash.new([])
  activities.each do |activity|
    bunk_name = activity[:bunk_name]
    bunks[bunk_name.to_sym] += [activity]
  end
  bunks
end

def sort_activities_by_time_slots(bunk_activities)
  bunk_activities.each_value do |activities|
    activities.sort_by! { |activity| activity[:start_time] }
  end
end

def generate_empty_schedule(gender)
  all_time_slots = @database.all_time_slots
  all_bunks = @database.all_bunks(gender)
  DailySchedule.new(nil, all_time_slots, nil, all_bunks, true)
end

def collect_time_slots(results)
  time_slots = []
  results.each do |activity|
    time_slots << [activity[:time_slot_id], activity[:start_time]] unless time_slots.include?([activity[:time_slot_id], activity[:start_time]])
  end
  time_slots
end

def generate_list_of_bunks(results)
  bunks = Hash.new([])

  results.each do |activity|
    bunks[activity[:bunk_name]] += [activity[:start_time] => Activity.new(activity[:activity], activity[:location])]
  end
  bunks
end

def restructure_bunks(bunks_unstructured)
  bunks_unstructured.map do |name, activities|
    bunk = Bunk.new(name)
    bunk.todays_schedule = Hash[*activities.map(&:to_a).flatten]
    bunk
  end
end