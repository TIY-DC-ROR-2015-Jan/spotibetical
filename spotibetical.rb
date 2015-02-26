require 'sinatra/base'
require 'madison'
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

["/users/profile", "/users/profile/*", "/add_song"].each do |path|
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
      session[:error_message] = "Invalid credentials. Try again."
      status 422
      erb :login
    end
  end

  delete '/users/logout' do
    session.delete :user_id
    redirect to('/')
  end

  get '/display' do
    @songs = []
    case  
    when params["sort"] == "alpha"
      @songs = Song.artist_order(params["limit"])
    else #set recent to default (same as 'when == "recent"')
      @songs = Song.most_recent(params["limit"]) #for testing, making this "song_id", but could also be created_at
    end
    @songs
    erb :display
  end


  get '/add_song' do
    erb :add_song
  end

  post '/add_song' do
    spotify_id = params[:spotify_id]
    # The vote group said adding songs uses a vote so we need to check the user has votes left here
    if Song.find_by(spotify_id: spotify_id).nil?
      if Song.found?(spotify_id)  == false
        session[:error_message] = "Couldn't find the song on Spotify, please try again."
        erb :add_song
      else
        current_user.addsong spotify_id
        erb :add_song
      end
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
