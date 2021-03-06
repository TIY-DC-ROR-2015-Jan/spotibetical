require 'minitest/autorun'
require 'pry'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

ENV['TEST'] = 'true'
require './db/setup'
require './lib/all'

class MiniTest::Test
  def setup
    @song_counter = 1
    [User, Song, Vote, Playlist].each { |klass| klass.delete_all }
  end

  def create_song! attrs={}
    attrs[:user_id]      ||= @song_counter
    attrs[:spotify_id]   ||= '-' * @song_counter
    attrs[:preview_link] ||= 'google.com'
    attrs[:artist]       ||= @song_counter
    attrs[:title]        ||= attrs[:artist]
    @song_counter += 1
    Song.create! attrs
  end

  def create_user! attrs={}
    attrs[:email]    ||= 'brit@kingcons.io'
    attrs[:password] ||= 'hunter2'
    attrs[:name]     ||= 'Brit Butler'
    attrs[:password] = Digest::SHA1.hexdigest attrs[:password]
    User.create! attrs
  end
end
