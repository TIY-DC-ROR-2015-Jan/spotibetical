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
    u = User.create! name: 'Brit Butler', email: 'brit@kingcons.io', password: 'password'
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

end

Spotibetical.run!