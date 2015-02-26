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
    create_user! email: 'brit@kingcons.io', password: 'hunter2'
  end

  def test_songs_have_spotify_id
    post '/users/login', email: 'brit@kingcons.io', password: 'hunter2'
    post '/add_song', spotify_id: "0cgz0Fa7bivUEwqI5Srj1P"
    assert_equal Song.first.spotify_id, "0cgz0Fa7bivUEwqI5Srj1P"
  end

  def test_addsong_adds_song
    u = User.first
    u.addsong "1kNaeeLr7uxdmER8XDS928"
    assert_equal Song.first.title, "Cairo"
  end

  def test_user_can_add_songs
    post '/users/login', email: 'brit@kingcons.io', password: 'hunter2'
    post '/add_song', spotify_id: "0cgz0Fa7bivUEwqI5Srj1P"
    assert_equal Song.first.artist, "Opeth"
  end

  def test_songs_cannot_be_repeated
    song_ids = []
    post '/users/login', email: 'brit@kingcons.io', password: 'hunter2'
    post '/add_song', spotify_id: "0cgz0Fa7bivUEwqI5Srj1P"
    post '/add_song', spotify_id: "0cgz0Fa7bivUEwqI5Srj1P"
    post '/add_song', spotify_id: "30J50x380IFf1P1H0DOtW4"
    post '/add_song', spotify_id: "30J50x380IFf1P1H0DOtW4"
    post '/add_song', spotify_id: "0nGvqi1Tjp0pWVGWJfA5yO"
    post '/add_song', spotify_id: "0nGvqi1Tjp0pWVGWJfA5yO"
    assert Song.all.count == 3
    Song.find_each do |x|
      song_ids << x.spotify_id
    end
    assert_equal song_ids.uniq!, nil
  end
end
