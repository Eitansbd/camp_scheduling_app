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

