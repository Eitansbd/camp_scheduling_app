# calendars_controller.rb
require_relative 'application_controller.rb'
require 'date'
require 'pry'



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

    redirect '/calendar/new' if @calendar_months.empty?

    erb :calendar
  end

  get '/calendar/new' do
    erb :new_calendar  # work in progress
  end

  post '/calendar/new' do  # Need to work on this/maybe get rid of it
      start_day = params[:start_date] # format - "YYYY-MM-DD"
      end_day = params[:end_date]
      dates_array = generate_dates(start_day, end_day)

      @database.add_calendar(dates_array)

      redirect '/calendar'
  end

  private
    def generate_dates(start_day, end_day)
      start_day = Date.parse(start_day)
      end_day = Date.parse(end_day)
      camp_dates = start_day.step(end_day).to_a
    end
end