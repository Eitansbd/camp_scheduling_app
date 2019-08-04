require 'sinatra/base'

require_relative './app/models/schedule_database.rb'
Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }


run ApplicationController
use CalendarsController
use ActivitiesController
use TimeSlotsController
use DivisionsController
use BunksController
use DailySchdulesController
