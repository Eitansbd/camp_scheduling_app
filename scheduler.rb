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
end

get '/' do
  day_id = @database.get_todays_day_id
  time_slots = @database.all_time_slots
  activities = @database.all_activities
  bunks = @database.all_bunks
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
  activity = Activity.new(params[:name], params[:location],
                          params[:youngest_division], params[:oldest_division],
                          params[:max_bunks])
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

post '/bunk/new' do # works
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

get '/dailyschedule/new' do
  @daily_schedule = @database.get_default_schedule

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

    # sql = <<~SQL
    #     SELECT * FROM schedule AS s
    #     JOIN days AS d ON d.id = s.day_id 
    #     WHERE date_part('year', calendar_date) = date_part('year', CURRENT_DATE);
    #   SQL

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
  @daily_schedule = @database.get_daily_schedule(day_id)

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

# def restructure_bunks(bunks_unstructured)
#   bunks_unstructured.map do |name, activities|
#     bunk = Bunk.new(name)
#     bunk.todays_schedule = Hash[*activities.map(&:to_a).flatten]
#     bunk
#   end
# end
