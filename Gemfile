source 'https://rubygems.org'

ruby '2.2.0'

gem 'activerecord'
gem 'sinatra', git: 'https://github.com/sinatra/sinatra.git'
gem 'httparty'

gem 'dotenv'
gem 'madison'

gem 'mandrill-api'

gem 'rake'
gem 'pry'
gem 'rollbar'

gem 'rollbar'

group :development, :test do
  gem 'sqlite3'
end

group :test do
  gem 'coveralls', require: false
  gem 'minitest'
  gem 'rack-test'
  gem 'simplecov', require: false
end

group :production do
  gem 'pg'
end