require 'dotenv'
Dotenv.load

require 'active_record'
require 'yaml'

if ENV["DATABASE_URL"]
  # For production / deployment on Heroku
  ActiveRecord::Base.establish_connection ENV["DATABASE_URL"]

else
  db_config = YAML::load(File.open('config/database.yml'))

  env_config = if ENV["TEST"]
    db_config["test"]
  else
    ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDERR)
    db_config["development"]
  end

  raise "Could not find database config for environment" unless env_config
  ActiveRecord::Base.establish_connection(env_config)
end