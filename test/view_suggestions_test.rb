require './test/helper'

class ViewSuggestionsTest < MiniTest::Test
  def setup
    User.delete_all
    Song.delete_all
    # [User, Song].each &:delete_all
  end

  def test_songs_have_artists
    x = Song.create! artist: 'abc', title: '123', spotify_link: 'google.com', user_id: 1, spotify_id: '-'

    assert_match x.artist, "abc"
  end

  def test_songs_have_ids
    x = Song.create! artist: 'jbc', title: '123', spotify_link: 'google.com', user_id: 2, spotify_id: '-'

    assert x.id
  end

  def test_songs_can_be_sorted
    Song.create! artist: 'jbc', title: '123', spotify_link: 'google.com', spotify_id: '-', user_id: 2
    Song.create! artist: 'acb', title: '123', spotify_link: 'google.com', spotify_id: '--', user_id: 3
    Song.create! artist: 'bbc', title: '123', spotify_link: 'google.com', spotify_id: '---', user_id: 4
    Song.create! artist: 'cbc', title: '123', spotify_link: 'google.com', spotify_id: '----', user_id: 5
    Song.create! artist: 'abd', title: '123', spotify_link: 'google.com', spotify_id: '------', user_id: 6

    #Not sure what to write here since display thing 
  end
end
