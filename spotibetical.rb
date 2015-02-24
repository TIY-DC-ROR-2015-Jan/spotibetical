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
    else
      @error = true
      erb :login
    end
  end

  delete '/users/logout' do
    session.delete :user_id
    redirect to('/')
  end

  get '/vote' do
    erb :voting
  end

  patch '/vote' do
    if current_user.vote_count >= params['songs'].count
      params['songs'].each do |song|
        current_user.votes.create!(song_id: song)
        current_user.vote_count -= 1
        current_user.save!
      erb :voting
    end
  end
    
    
  end

Spotibetical.run!