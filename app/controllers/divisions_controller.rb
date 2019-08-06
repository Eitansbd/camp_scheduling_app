#divions_controller.rb
require_relative 'application_controller.rb'

class DivisionsController < ApplicationController
  set :views, [File.expand_path('../../views/divisions', __FILE__),
              File.expand_path('../../views/', __FILE__)]

  get '/divisions' do
    @all_divisions = @database.all_divisions
    erb :divisions
  end

  get '/divisions/new' do # Works
    erb :new_division
  end

  post '/divisions/new' do
    name, age = params[:name], params[:age]

    @database.add_division(name, age)

    session[:message] = "#{name} successfully added to the database."

    redirect '/divisions'
  end

  get '/divisions/:division_id/edit' do
    @division_id = params[:division_id].to_i
    @division = @database.get_division(@division_id)

    erb :edit_division
  end

  post '/divisions/:division_id/edit' do
    id = params[:division_id]
    name = params[:name]
    age = params[:age]

    @database.edit_division(id, name, age)

    session[:message] = "Successfully changed #{name}."

    redirect '/divisions'
  end

  post '/divisions/:division_id/delete' do
    id = params[:division_id].to_i

    @database.delete_division(id)

    session[:message] = "Division has been deleted"

    redirect '/divisions'
  end
end