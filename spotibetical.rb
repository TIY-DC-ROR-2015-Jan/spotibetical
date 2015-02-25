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
    Song.create! artist: 'abc', title: '123', spotify_link: 'google.com', user_id: 1
    Song.create! artist: 'jbc', title: '123', spotify_link: 'google.com', user_id: 2
    Song.create! artist: 'lbc', title: '123', spotify_link: 'google.com', user_id: 3
    Song.create! artist: 'tbc', title: '123', spotify_link: 'google.com', user_id: 4
    Song.create! artist: 'cbc', title: '123', spotify_link: 'google.com', user_id: 5
    Song.create! artist: 'bbc', title: '123', spotify_link: 'google.com', user_id: 6

    @songs = Song.all
    erb :display
  end

  get '/display/sort' do
  
    @songs = []
    if params["alpha"] == true.to_s
      song_list = Song.all
      s = Song.get_artist_letter song_list
      t = s.sort_by{|k,v| k}
      t.each {|a| @songs << a[1]}
    end
    if params["recent"] == true.to_s
      @songs = Song.order(created_at: :desc)
    end
    @songs
    erb :display
  end

end

Spotibetical.run!