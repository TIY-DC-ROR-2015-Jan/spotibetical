require 'sinatra/base'
require 'madison'
require 'pry'
require 'rollbar'
require 'mandrill'
require 'digest'

require './db/setup'
require './lib/all'


if ENV['ROLLBAR_ACCESS_TOKEN']
  Rollbar.configure do |config|
    config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  end
end

class Spotibetical < Sinatra::Base

  enable :sessions, :method_override
  set :session_secret, ENV.fetch('SESSION_SECRET', 'super_secret')

  error do
    Rollbar.error env['sinatra.error']
  end

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


  def ensure_admin!
    unless current_user.admin == true
      session[:error_message] = "Nope, nothing to see here." #Unhelpful error message is unhelpful.
      redirect '/'
    end
  end

  def ci?
    ENV["CI"] == "true"
  end

  get '/' do
    @users = User.all
    @pl = Playlist.generate_leaderboard 
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
      password: Digest::SHA1.hexdigest(params[:password])
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
      song_found = current_user.addsong spotify_id      
        unless song_found == false
          redirect to("/display")
        else
          session[:error_message] = "Couldn't find the song on Spotify, please try again."
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
      current_user.veto! params["song_id"].to_i
    end
    redirect to('/')
  end

  get '/create_account' do
    ensure_admin!
    erb :new_user
  end

  post '/create_account' do
    ensure_admin!
    begin
      x = User.create!(name: params["name"], email: params["email"], password: Digest::SHA1.hexdigest(params[:password]))
      unless ci?
        m = Mandrill::API.new(ENV.fetch "MANDRILL_APIKEY")
        m.messages.send(x.welcome_email)
      end
      session[:success_message] = "User account for #{x.name} created successfully. Account ID is #{x.id}. Invite email sent to #{x.email}."
    rescue
      session[:error_message] = "User creation failed. Please try again."
    ensure
      redirect '/create_account'
    end
  end

  # get '/delete_account' do
    # ensure_admin!
    # erb :delete_user
    # Need to add session scope and usr attribute to active/inactive
  # end

  #assumes app is private and only open to cohort
  get '/update_admin' do
    ensure_admin!
    @users = User.all
    erb :update_admin
  end  

  patch '/update_admin' do
    ensure_admin!
    if params["action"] == "enable"
      User.find(params["id"]).update!(admin: true)
      session[:success_message] = "Success! User #{User.find(params["id"]).name}, ID #{params["id"]}, admin privileges GRANTED."
      redirect '/update_admin'
    elsif params["action"] == "disable"
      x = User.find(params["id"]).update!(admin: false)
      session[:success_message] = "Success! User #{User.find(params["id"]).name}, ID #{params["id"]}, admin privileges REVOKED."
      redirect '/update_admin'
    else
      session[:error_message] = "There was an error updating admin privileges for User ID #{params["id"]}. Please try again."
      redirect '/update_admin'
    end
  end

end

Spotibetical.run! if $PROGRAM_NAME == __FILE__
