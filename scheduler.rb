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
end

get '/' do
  date = "June 24th"
  time_slots = @database.all_time_slots
  activities = @database.all_activities
  bunks = @database.all_bunks
  @todays_schedule = DailySchedule.new(date, time_slots, activities, bunks)
  @todays_schedule.schedule_all_activities
  erb :daily_schedule
end

post '/calendar_days/generate' do  # make the form for this
    start_day = '2019-08-01' # params[:start_day]
    end_day = '2019-09-01' # params[:end_day]
    month_calendar = generate_calendar(start_day, end_day)
    reidrect '/'
end

get '/activity/new' do
  erb :new_activity
end

post '/activity/new' do
  # instantiates a new activity object
  activity = Activity.new(params[:name], params[:location], params[:youngest_division], params[:oldest_division], params[:max_bunks])
  # adds the activity to the database
  @database.add_activity(activity)
  redirect '/'
end

get '/time_slot/new' do
  # renders page to add new time slot
  erb :new_time_slot
end

# adds a new time slot to the database
post '/time_slot/new' do
  name = params[:name]
  start_time = params[:start_time]
  end_time = params[:end_time]

  @database.add_time_slot(name, start_time, end_time)
end

get '/calendar/new' do
  erb :new_calendar  # work in progress
end

get '/division/new' do
  erb :new_division
end

post '/division/new' do
  name, age = params[:name], params[:age]

  @database.add_division(name, age)

end

get '/bunk/new' do
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

get '/bunk/:bunk_id' do
  id = params[:bunk_id].to_i
  @bunk = @database.load_bunk(id)

  erb :bunk_page
end

get '/bunk/:bunk_id/daily_schedule/:day_id' do
  # renders page for a bunks daily schedule, including previous ones
  # retrives from database the schedule based on bunk id and day id
  bunk_id = params[:bunk_id].to_i
  day_id = params[:day_id].to_i
  @bunk = @database.load_bunk(bunk_id)
  @bunk_schedule = get_bunk_schedule(bunk_id, day_id)
  erb :bunk_schedule
end

get '/bunk/:bunk_id/activities_history' do
  # renders page that displays the amount of times (and days?) that
  # a specific bunk had individual activities
  bunk_id = params[:bunk_id].to_i
  @activity_history = get_bunk_activity_history(bunk_id) # returns a hash with 
  # keys being the day of the month, values being and array or the activities 
  # on that day. The activity itself is a hash with the keys and values 
  # representing the title and details.
  erb :bunk_activity_history # create a page to display the history
end

get '/dailyschedule/:day_id' do
  # renders page of a daily schedule based on the id. Needs to load the schedule
  # from the database.
  day_id = params[:day_id].to_i
  # returns an array of all of the days activities
  results = @database.get_daily_schedule(day_id)
  erb :daily_schedule # still need this page
end

get '/dailyschedule/:day_id/edit' do
  # renders edit page for daily schedule.

end

get '/dailyschedule/new' do
  # renders new schedule page. Should load bunks and time slots and have a drop
  # down menu for each time slot. -- the name should be 3 digits - bunk_id, time_id
  # and day_id. Not sure how to deal with the issue that we need dyamic drop downs
  # to get rid of activities that were just chosen. Page should
end

post '/dailyshchedule/new' do

  # creates the daily schedule - maybe loads template for a new schedule. Fills
  # in anything that is defined by the user in the post. Then calls the schedule
  # all activities method to assign the rest of the schedule
end

def get_bunk_activity_history(bunk_id)
  # get the months camp calendar  
  days = @database.get_days_in_month # make this method
  # call the bunk schedule method for each day in the month
  result = {}
  days.each do |tuple|
    day_id = tuple["id"]
    one_day_schedule = @database.get_bunk_schedule(bunk_id, day_id)
    result[tuple["calendar_date"]] = one_day_schedule
  end
  result
end

def generate_calendar(start_day, end_day)
  date = Date.parse(start_day)
  end_date = Date.parse(end_day)
  while date <= end_date do
    @database.add_date(date.to_s)
    date = date.next
  end
end
