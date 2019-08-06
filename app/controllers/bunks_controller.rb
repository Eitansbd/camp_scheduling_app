#bunks_controller.rb

require_relative 'application_controller.rb'
require_relative '../models/bunk.rb'

class BunksController < ApplicationController

  set :views, [File.expand_path('../../views/bunks', __FILE__),
               File.expand_path('../../views/', __FILE__)]

  helpers do
    def bunk_schedule_keys(bunk_schedule)
      bunk_schedule.first.keys
    end

    def bunk_schedule_data(bunk_schedule)
      bunk_schedule.map do |activity|
        [
         activity["Activity"],   activity["Location"],
         activity["Start Time"], activity["End Time"]
        ]
      end
    end

    def display_bunk_activity_history(bunk)
      results = Hash.new([])
      bunk.activity_history.each do |date, activities|
        activities.each do |activity|
          results[activity.name] += [date]
        end
      end

      ordered_results = results.sort_by { |_, dates| dates.size }.reverse

      ordered_results.each do |activity, dates|
        yield(activity, dates.size, dates)
      end
    end

  end

  get '/bunks' do
    @all_bunks = @database.all_bunks
    erb :bunks
  end

  get '/bunks/:bunk_id/info' do  # Works but could use improvement
    bunk_id = params[:bunk_id].to_i

    @bunk = @database.load_bunk_with_activity_history(bunk_id)
    @bunk_schedule = @database.get_bunk_schedule(bunk_id)

    erb :bunk_info
  end

  get '/bunks/:bunk_id/dailyschedules/:day_id' do  # Works
    # renders page for a bunks daily schedule, including previous ones
    # retrives from database the schedule based on bunk id and day id
    bunk_id = params[:bunk_id].to_i
    #day_id = @database.get_day_id_from_date(day_id)
    @bunk = @database.load_bunk(bunk_id)
    @bunk_schedule = @database.get_bunk_schedule(bunk_id)
    erb :bunk_schedule
  end

  # get '/bunks/:bunk_id/activities_history' do  # Works
  #   # renders page that displays the amount of times (and days?) that
  #   # a specific bunk had individual activities
  #   bunk_id = params[:bunk_id].to_i
  #   @bunk_activity_history = @database.get_bunk_activity_history(bunk_id)

  #   erb :bunk_activity_history
  # end

  get '/bunks/new' do  # Works
    @divisions = @database.all_divisions
    erb :new_bunk
  end

  post '/bunks/new' do # works
    bunk = Bunk.new(params[:name], params[:division], params[:gender])

    begin
      @database.add_bunk(bunk)
      session[:message] = "#{bunk.name} successfully added to the database."
      redirect '/bunks'
    rescue PG::UniqueViolation
      session[:message] = "bunk names must be unique"
      status 403
      @divisions = @database.all_divisions
      erb :new_bunk
    end
  end

  get '/bunks/:bunk_id/edit' do
    id = params[:bunk_id].to_i
    @bunk = @database.load_bunk(id)
    @divisions = @database.all_divisions
    erb :edit_bunk
  end

  post '/bunks/:bunk_id/edit' do
    bunk = Bunk.new(params[:name], params[:division], params[:gender], params[:bunk_id].to_i)

    @database.edit_bunk(bunk)

    session[:message] = "Successfully changed #{bunk.name}."

    redirect '/bunks'
  end

  post '/bunks/:bunk_id/delete' do
    id = params[:bunk_id]

    @database.delete_bunk(id)

    session[:message] = "Bunk has been deleted"

    redirect '/bunks'
  end
end