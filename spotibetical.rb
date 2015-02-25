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

  get '/users/profile' do
    @u= current_user
    erb :user_profile
  end

  get '/users/profile/edit' do
    @u= current_user
    erb :user_profile_edit
  end

  patch '/users/profile/edit' do
    if current_user
      u = current_user
      if params["avatar_url"] !=""
        u.avatar_url=params["avatar_url"]
        u.save!
      end 
      if params["bio"] !=""
        u.bio=params["bio"]
        u.save!
      end
      if params["home_state"] !=""
        u.home_state=params["home_state"]
        u.save!
      end
      if params["zodiac_sign"] !=""
        u.zodiac_sign=params["zodiac_sign"]
        u.save!
      end
      if params["favorite_song_url"] !=""
        u.favorite_song_url=params["favorite_song_url"]
        u.save!
      end
    else
      redirect to('/users/login')
    end
    redirect to('/users/profile')
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
end

Spotibetical.run!