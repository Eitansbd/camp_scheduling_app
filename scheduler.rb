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

<<<<<<< HEAD
require_relative 'schedule_database'

class Bunk
  attr_reader :name, :todays_schedule, :division, :gender

  def initialize(name, division = "Hey", gender = "M")
    @name = name
    @division = division
    @gender = gender
    @default_activities = { 7  => Activity.new("Shacharit"),
                            12 => Activity.new("Lunch"),
                            10 => Activity.new("Shiur") }
    @todays_schedule = {}
  end

  def default_activity(start_time)
    @default_activities[start_time]
  end

  def default_activity=(start_time, activity)
    #change the default activity for a bunk
  end

  def valid_activity?(activity)
    # determine if an activity is valid, based on
    !@todays_schedule.include?(activity)
  end

  def add_to_schedule(time, activity)
    @todays_schedule[time] = activity
  end

  def activity_at(time_slot)
    @todays_schedule[time_slot]
  end

  def schedule_default_activities
    @default_activities.each do |time, activity|
      self.add_to_schedule(time, activity)
    end
  end

  def has_activity_scheduled?(time_slot)
    !!activity_at(time_slot)
  end

  def display_schedule
    printing_schedule_format = @todays_schedule.map do |time, activity|
      (activity ? activity.name : "").rjust(12)
    end.join(", ")
    puts "#{name.rjust(3)}: #{printing_schedule_format}"
  end
=======
before do
  @database = ScheduleDatabase.new(logger)
>>>>>>> master
end

get '/' do

  erb :daily_schedule
end

get '/bunk/:bunk_id' do
  # renders page for each bunk
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
end

get '/bunk/:bunk_id/activities_history' do
  # renders page that displays the amount of times (and days?) that
  # a specific bunk had individual activities
end

get '/dailyschedule/:day_id' do
  # renders page of a daily schedule based on the id. Needs to load the schedule
  # from the database.
end

get '/dailyschedule/:day_id/edit' do
  # renders edit page for daily schedule.
end

<<<<<<< HEAD
 # List of activity names
       # ("Lake Toys,Drama,Basketball,Art,Music,Softball,Tennis," +
       #  "Taboon,Chavaya,Hockey,Hockey,Hockey,Hockey,Biking,Volleyball," +
       #  "a1, a2, a3, a4, a5, a6").split(",")

# ACTIVITES = all_activities.map { |name| Activity.new(name) }  # Calls the 'all_activities' method from the API
# BUNKS = all_bunks.to_a.map { |name| Bunk.new(name) } # Calls the bunks_names method from the API
# TIME_SLOTS = all_time_slots # Calls the all_time_slots method from API
#
# todays_schedule = DailySchedule.new("June 16, 2019")
# todays_schedule.display_schedule

db = ScheduleDatabase.new(nil)
#db.add_bunk(Bunk.new("b2"))
p db.all_bunks
=======
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

>>>>>>> master
