#bunks_controller.rb

require_relative 'application_controller.rb'
require_relative '../models/bunk.rb'

class BunksController < ApplicationController
  get '/bunks' do
    @all_bunks = @database.all_bunks
    erb :bunks
  end

  get '/bunks/:bunk_id/info' do  # Works but could use improvement
    id = params[:bunk_id].to_i
    day_id = @database.get_todays_day_id
    @bunk = @database.load_bunk(id)
    @bunk_schedule = @database.get_bunk_schedule(id, day_id) if day_id
    @database.populate_bunk_activity_history(@bunk)
    erb :bunk_info
  end

  get '/bunks/:bunk_id/dailyschedule/:date' do  # Works
    # renders page for a bunks daily schedule, including previous ones
    # retrives from database the schedule based on bunk id and day id
    bunk_id = params[:bunk_id].to_i
    @date = params[:date]
    day_id = @database.get_day_id_from_date(@date)
    @bunk = @database.load_bunk(bunk_id)
    @bunk_schedule = @database.get_bunk_schedule(bunk_id, day_id)
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
    erb :new_bunk
  end

  post '/bunks/new' do # works
    bunk = Bunk.new(params[:name], params[:division], params[:gender])

    @database.add_bunk(bunk)

    session[:message] = "#{bunk.name} successfully added to the database."

    redirect '/bunks'
  end

  get '/bunks/:bunk_id/edit' do
    id = params[:bunk_id].to_i
    @bunk = @database.load_bunk(id)
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