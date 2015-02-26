require 'sinatra/base'
require 'madison'
require 'pry'
require 'rollbar'

require './db/setup'
require './lib/all'

if ENV['ROLLBAR_ACCESS_TOKEN']
  Rollbar.configure do |config|
    config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  end
end

class Spotibetical < Sinatra::Base
  enable :sessions, :method_override
  set :session_secret, 'super secret'

  LOGIN_REQUIRED_ROUTES = [
    "/users/profile",
    "/users/profile/*",
    "/add_song"
  ]

  def current_user
    if session[:user_id]
      User.find session[:user_id]
    end
  end

  LOGIN_REQUIRED_ROUTES.each do |path|
    before path do
      if current_user.nil?
        session[:error_message] = "You must log in to see this feature."
        session[:return_trip] = path
        redirect to('/users/login')
      end
    end
  end

  get '/' do
    erb :home
  end

  get '/users/login' do
    erb :login
  end

  get '/users/profile' do
    erb :user_profile
  end

  get '/users/profile/edit' do
      @states = Madison.states
      @zodiac_signs = %w( Aries Taurus Gemini Cancer Leo Virgo Libra Scorpio Sagittarius Capricorn Aquarius Pisces)
      erb :user_profile_edit
  end

  patch '/users/profile/edit' do
      u = current_user
      present_params = params.select { |k,v| v != current_user[k] }
      present_params.delete "_method"
      u.update present_params if present_params.any?
      redirect to('/users/profile')
  end

  post '/users/login' do
    user = User.where(
      email:    params[:email],
      password: params[:password]
    ).first  
    
    if user
      session[:user_id] = user.id
      if session["return_trip"]
        path = session["return_trip"]
        session.delete("return_trip")
        redirect to(path)
      else
        redirect to('/')
      end
    else
      @error = true
      status 422
      erb :login
    end
  end

  delete '/users/logout' do
    session.delete :user_id
    redirect to('/')
  end

  get '/display' do
    if params["sort"] == "alpha"
      @songs = Song.artist_order(params["limit"])
    else #set recent to default (same as 'when == "recent"')
      @songs = Song.most_recent(params["limit"]) #for testing, making this "song_id", but could also be created_at
    end

    erb :display
  end

  get '/add_song' do
    erb :add_song
  end

  post '/add_song' do
    spotify_id = params[:spotify_id]
    # The vote group said adding songs uses a vote so we need to check the user has votes left here
    if Song.find_by(spotify_id: spotify_id).nil?
      current_user.addsong spotify_id
      redirect to('/add_song')
    else
      session[:error_message] = "Somebody already suggested that. Be original."
      erb :add_song
    end
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
