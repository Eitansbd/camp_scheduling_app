# calendars_controller.rb
require_relative 'application_controller.rb'

class CalendarsController < ApplicationController
  set :views, [File.expand_path('../../views/calendars', __FILE__),
               File.expand_path('../../views/', __FILE__)]

  get '/calendar' do
    calendar_days = @database.get_days_in_current_session

    @calendar_months = Hash.new([])
    calendar_days.each do |day|
      month = day[:calendar_date].mon
      @calendar_months[month] += [day]
    end

    rerdirect '/calendar/new' if @calendar_months.empty?

    erb :calendar
  end

  get '/calendar/new' do
    erb :new_calendar  # work in progress
  end

  post '/calendar/new' do  # Need to work on this/maybe get rid of it
      start_day = params[:start_date] # params[:start_day]
      end_day = params[:end_date] # params[:end_day]
      calendar = generate_calendar(start_day, end_day)
      @database.add_calendar(calendar)

      redirect '/calendar'
  end
end