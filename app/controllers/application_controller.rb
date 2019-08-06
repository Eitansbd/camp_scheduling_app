# application_controller.rb
require 'sinatra/base'
require 'sinatra/reloader'

class ApplicationController < Sinatra::Base
  set :views, File.expand_path('../../views', __FILE__)

  set :public_folder, File.expand_path('../../../public', __FILE__)


  configure :development do
    register Sinatra::Reloader
  end

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  before do
    @database = CampDatabase.new(logger)
  end

  helpers do
    def find_template(views, name, engine, &block)
      Array(views).each { |v| super(v, name, engine, &block) }
    end

    def divisions
      @database.all_divisions
    end

    # takes in the daily schedule and yields to a block the bunk and an array of
    # the activities the bunk has that day in order
    def all_bunks_activities(daily_schedule)
      bunks = daily_schedule.bunks

      bunks.each do |bunk|
        activities = []
        time_slot_ids = []

        daily_schedule.schedule.each do |_, (bunk_activities_hash)|
          activities << bunk_activities_hash[bunk]
        end

        yield(bunk, activities)

      end
    end

    def daily_schedule_time_slots(daily_schedule)
      ["Bunk"] + daily_schedule.time_slots
    end

    def available_activities
      @database.all_activities.each{ |activity| yield(activity.id, activity.name, activity.location) }
    end

    def available_dates
      @database.get_days_in_month.map { |day| day.values }
    end

    def date_of_schedule(daily_schedule)
      day_id = daily_schedule.day_id
      date = @database.get_date_from_day_id(day_id)
    end
  end

  get '/' do
    day_id = @database.get_todays_day_id

    if day_id
      @daily_schedule = @database.get_daily_schedule(day_id)
      redirect "/dailyschedules/#{day_id}"
    else
      erb "there is no schedule for today"
    end
  end
end