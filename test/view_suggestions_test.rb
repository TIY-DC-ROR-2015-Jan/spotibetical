require './test/helper'

class ViewSuggestionsTest < MiniTest::Test

  include Rack::Test::Methods
  def app
  # Note that we needed to include the app so we can write tests about it,
  # hence the added `$PROGRAM_NAME == __FILE__` check there
  Spotibetical
  end

  def setup
    User.delete_all
    Song.delete_all
    # [User, Song].each &:delete_all
  end

  def test_songs_have_artists
    x = Song.create! artist: 'abc', title: '123', spotify_link: 'google.com', user_id: 1

    assert_match x.artist, "abc"
  end

  def test_songs_have_ids
    x = Song.create! artist: 'jbc', title: '123', spotify_link: 'google.com', user_id: 2

    assert x.id? 
  end

  def test_songs_can_be_sorted
    Song.create! artist: 'jbc', title: '123', spotify_link: 'google.com', user_id: 2
    Song.create! artist: 'acb', title: '123', spotify_link: 'google.com', user_id: 3
    Song.create! artist: 'bbc', title: '123', spotify_link: 'google.com', user_id: 4
    Song.create! artist: 'cbc', title: '123', spotify_link: 'google.com', user_id: 5
    Song.create! artist: 'abd', title: '123', spotify_link: 'google.com', user_id: 6

    x = Song.artist_order
    assert_equal x.first.artist, 'abd'
  end

  def test_display_handler_works
    #need to write this
  end

  # def test_sort_limits_can_be_changed
  # end

  # def test_display_increments_pages_correctly
  # end
end