require 'minitest/autorun'
require 'pry'

ENV['TEST'] = 'true'
require './db/setup'
require './lib/all'

class MiniTest::Test
  def setup
    [User, Song, Vote, Playlist].each { |klass| klass.delete_all }
  end
end
