require 'sinatra/base'
require 'pry'

require './db/setup'
require './lib/all'
binding.pry
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

  post '/addsong' do
    spotify_id = params[:spotify_id]

    if songs.find_by(spotify_id: spotify_id).count > 0
      @error = true
      erb :addsong
    else
      current_user.addsong spotify_id
      erb :addsong
    end
  end
end

Spotibetical.run!