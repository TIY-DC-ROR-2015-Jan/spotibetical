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

# this demos what the voting button looks like
  get '/vote' do
    erb :voting
  end

  patch '/vote' do
    if current_user
      current_user.vote params["songs"]
    end
  end

  patch '/veto' do
    if current_user
      current_user.veto! params["song_id"]
    end
  end
    
  end

Spotibetical.run! if $PROGRAM_NAME == __FILE__