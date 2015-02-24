require './test/helper'

class SongTest < MiniTest::Test

  def setup
    User.delete_all
    Song.delete_all
  end

  def test_songs_have_spotify_id
    s = Song.create! artist: 'The Pogues', title: 'If I Should Fall From Grace With God', user_id: 1, spotify_id: "1Z5rTFsClLFgsIGuZ7Ymt2"
    assert_equal s.spotify_id, "1Z5rTFsClLFgsIGuZ7Ymt2"
  end

  def test_addsong_adds_song
    u = User.create! name: 'Brit Butler', email: 'brit@kingcons.io', password: 'hunter2'
    u.addsong "1kNaeeLr7uxdmER8XDS928"

    assert_equal Song.first.title, "Cairo"
  end
end