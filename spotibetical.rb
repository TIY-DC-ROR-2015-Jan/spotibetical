require 'sinatra/base'
require 'pry'

require './db/setup'
require './lib/all'

class Spotibetical < Sinatra::Base
  enable :sessions, :method_override
  set :session_secret, 'super secret'

  def current_user
    if session[:user_id]
      User.find session[:user_id]
    end
  end

  get '/' do
    erb :home
  end

  get '/users/login' do
    erb :login
  end

  get '/users/profile' do
    if current_user
      erb :user_profile
    else
      redirect to('/users/login')
    end 
  end

  get '/users/profile/edit' do
    if current_user
      erb :user_profile_edit
    else
      redirect to('/users/login')
    end 
  end

  patch '/users/profile/edit' do
    if current_user
      u = current_user
      present_params = params.select { |k,v| v != "" }
      present_params.delete "_method"
      u.update present_params if present_params.any?
      redirect to('/users/profile')
    else
      redirect to('/users/login')
    end
  end

  post '/users/login' do
    user = User.where(
      email:    params[:email],
      password: params[:password]
    ).first

    if user
      session[:user_id] = user.id
      redirect to('/')
    else
      @error = true
      erb :login
    end
  end

  delete '/users/logout' do
    session.delete :user_id
    redirect to('/')
  end
end

Spotibetical.run!