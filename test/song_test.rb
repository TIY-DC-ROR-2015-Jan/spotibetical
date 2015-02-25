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

  def test_songs_have_spotify_id
    s = create_song! artist: 'The Pogues', title: 'If I Should Fall From Grace With God', spotify_id: "1Z5rTFsClLFgsIGuZ7Ymt2"
    assert_equal s.spotify_id, "1Z5rTFsClLFgsIGuZ7Ymt2"
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
