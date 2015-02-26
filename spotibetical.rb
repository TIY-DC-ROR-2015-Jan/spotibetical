require 'sinatra/base'
require 'pry'

require './db/setup'
require './lib/all'

require 'mandrill'

class Spotibetical < Sinatra::Base

  mdapikey = File.read('./mandrill_testapikey.txt') #UPDATE LN 150 with email and add API key before create user.

  enable :sessions, :method_override
  set :session_secret, 'super secret'

  def current_user
    if session[:user_id]
      User.find session[:user_id]
    end
  end

  def ensure_admin!
    unless current_user.admin == true
      session[:error_message] = "Nope, nothing to see here." #Unhelpful error message is unhelpful.
      redirect '/'
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
      # This should probably be connected to the suggested songs display table
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
      current_user.addsong spotify_id
      #erb :add_song
      redirect to('/add_song')
    else
      @error = "Somebody already suggested that. Be original."
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

  get '/create_account' do
    ensure_admin!
    erb :new_user
  end

  post '/create_account' do
    ensure_admin!
    begin
    x = User.create!(name: params["name"], email: params["email"], password: params["password"])
      m = Mandrill::API.new(mdapikey)
      m.messages.send(x.welcome_email)
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
