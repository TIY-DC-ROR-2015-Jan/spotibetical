require './test/helper'
require 'pry'
require './spotibetical'
require 'rack/test'

class SongTest < MiniTest::Test

  include Rack::Test::Methods
  def app
    Spotibetical
  end

  def setup
    super
    User.create! email: 'brit@kingcons.io', password: 'hunter2', name: 'Brit Butler'
  end

  def test_click_preview_plays_preview
    post '/users/login', email: 'brit@kingcons.io', password: 'hunter2'
    post '/add_song', spotify_id: "7IoK6jZBxY7NMoQPoPXZCF"
    s = Song.first
    assert_equal s.preview_link, "https://p.scdn.co/mp3-preview/8f572425ab51badcd2f845883399037fdab9d0c4"
  end

  def test_song_has_play_link
    post '/users/login', email: 'brit@kingcons.io', password: 'hunter2'
    post '/add_song', spotify_id: "7IoK6jZBxY7NMoQPoPXZCF"
    s = Song.first
    assert_equal s.play_link, "https://open.spotify.com/track/7IoK6jZBxY7NMoQPoPXZCF"
  end
end