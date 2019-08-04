# time_slots_controller.rb
require_relative 'application_controller.rb'

class TimeSlotsController < ApplicationController
  get '/time_slots' do
    @all_time_slots = @database.all_time_slots
    erb :time_slots
  end

  get '/time_slots/new' do # Works
    erb :new_time_slot
  end

  post '/time_slots/new' do  # Works
    start_time = params[:start_time]
    end_time = params[:end_time]

    @database.add_time_slot(start_time, end_time)

    session[:message] = "Time slot successfully added to the database."

    redirect '/time_slots'
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

    session[:message] = "Successfully changed time slot."

    redirect '/time_slots'
  end

  post '/time_slots/:time_slot_id/delete' do
    id = params[:time_slot_id].to_i

    @database.delete_time_slot(id)

    session[:message] = "Time slot has been deleted"

    redirect '/time_slots'
  end
end