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
    binding.pry
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

  get '/add_song' do
    erb :add_song
  end

  post '/add_song' do
    spotify_id = params[:spotify_id]
    binding.pry

    if Song.find_by(spotify_id: spotify_id).nil?
      binding.pry
            current_user.addsong spotify_id

      erb :add_song
    else
      binding.pry
      @error = true
      erb :add_song
    end
    binding.pry
  end
end

Spotibetical.run!