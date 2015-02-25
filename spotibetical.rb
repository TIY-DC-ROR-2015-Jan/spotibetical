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
      # This should probably be connected to the suggested songs display table
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
    # The vote group said adding songs uses a vote so we need to check the user has votes left here
    if Song.find_by(spotify_id: spotify_id).nil?
      current_user.addsong spotify_id
      #erb :add_song
      redirect to('/add_song')
    else
      @error = "Somebody already suggested that. Be original."
      erb :add_song
    end
  end
end

Spotibetical.run!