#daily_schedules_controller.rb
require_relative 'application_controller.rb'

class DailySchdulesController < ApplicationController
  set :views, [File.expand_path('../../views/daily_schedules', __FILE__),
               File.expand_path('../../views/', __FILE__)]

  helpers do
    def auto_schedule?(activity)
      activity.auto_schedule? ? "checked" : ""
    end
  end

  get '/dailyschedules/:day_id' do  # Works
    # renders page of a daily schedule based on the id. Needs to load the schedule
    # from the database.
    day_id = params[:day_id].to_i

    # returns an array of all of the days activities
    @daily_schedule = @database.get_daily_schedule(day_id)

    erb :daily_schedule
  end

  get '/dailyschedules/:day_id/new' do
    if env["HTTP_REFERER"] && env["HTTP_REFERER"].include?("/calendar")
      session[:message] = "No activities where scheduled for this day."
    elsif env["HTTP_REFERER"] && env["HTTP_REFERER"].include?("/dailyschedule")
      session[:message] = "Schedule has been reset. Changes are solidified when new schedule is saved."
    end

    day_id = params[:day_id]
    @date = @database.get_date_from_day_id(day_id)

    @daily_schedule = @database.get_default_schedule
    @activities = @database.all_activities

    erb :new_daily_schedule
  end

  post '/dailyschedules/:day_id/new' do  # Needs work
    day_id = params[:day_id]

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

    available_activities = []
    params.each do |key, value|
      if key.match(/^\d+/) && value == "auto-schedule"
        available_activities << key.to_i
      end
    end

    @daily_schedule.schedule_all_activities(available_activities)


    session[:message] = "Remaining activities have successsfully been autofilled into the schedule."

    erb :save_daily_schedule
    # creates the daily schedule - maybe loads template for a new schedule. Fills
    # in anything that is defined by the user in the post. Then calls the schedule
    # all activities method to assign the rest of the schedule


      # still need to fill in remaining calendar
  end

  post '/dailyschedules/:day_id/save' do

    day_id = params[:day_id]

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


    @database.delete_previous_daily_schedule(day_id)
    @database.add_daily_schedule(@daily_schedule)

    session[:message] = "Schedule has been successfully saved to the database."

    redirect '/calendar'
  end

  get '/dailyschedules/default/edit' do
    @default_schedule = @database.get_default_schedule
    erb :default_schedule
  end

  post '/dailyschedules/default/edit' do
    time_slots = @database.all_time_slots
    bunks = @database.all_bunks
    activities = @database.all_activities

    @default_schedule = DailySchedule.new(0, time_slots, activities, bunks)

    params.each do |key, value|
      next unless (key.match(/^\d+,\d+$/) && value != "")
      bunk_id, time_slot_id = key.split(',').map(&:to_i)
      activity_id = value.to_i
      activity = activities.find{ |act| act.id == activity_id }
      bunk = bunks.find { |bnk| bnk.id == bunk_id }
      @default_schedule.schedule[time_slot_id][bunk] = activity
      # returns a hash with all of the new activities to be stored in the database
    end

    @database.delete_previous_default_schedule
    @database.add_default_schedule(@default_schedule)

    session[:message] = "Successfully changed default schedule."

    redirect '/calendar'
  end

  get '/dailyschedules/:day_id/edit' do # Doesn't work

    @day_id = params[:day_id]
    @daily_schedule = @database.get_daily_schedule(@day_id)

    erb :edit_daily_schedule
  end
end