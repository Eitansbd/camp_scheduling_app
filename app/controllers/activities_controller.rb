# activities_controller.rb

require_relative 'application_controller.rb'

class ActivitiesController < ApplicationController
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

    session[:message] = "#{activity.name} successfully added to the database."

    redirect '/activities'
  end

  get '/activities/:activity_id/edit' do
    activity_id = params[:activity_id].to_i
    @activity = @database.get_activity(activity_id)

    erb :edit_activity
  end

  post '/activities/:activity_id/edit' do  # Works
    activity = Activity.new(params[:name], params[:location], params[:activity_id].to_i).set_activity_parameters(
                                                                  params[:max_bunks].to_i,params[:youngest_division],
                                                                  params[:oldest_division], params[:double])

    @database.edit_activity(activity)

    session[:message] = "Successfully changed #{activity.name}."

    redirect '/activities'
  end

  post '/activities/:activity_id/delete' do
    id = params[:activity_id].to_i

    @database.delete_activity(id)

    session[:message] = "Activity has been deleted"

    redirect '/activities'
  end
end