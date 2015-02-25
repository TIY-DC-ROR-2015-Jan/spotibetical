require './test/helper'

class ViewSuggestionsTest < MiniTest::Test
  def test_songs_have_artists
    x = create_song! artist: 'abc', title: '123'

    assert_match x.artist, "abc"
  end

  def test_songs_have_ids
    x = create_song! artist: 'jbc', title: '123'
    assert x.id
  end

  def test_songs_can_be_sorted
    create_song! artist: 'jbc', title: '123'
    create_song! artist: 'acb', title: '123'
    create_song! artist: 'bbc', title: '123'
    create_song! artist: 'cbc', title: '123'
    create_song! artist: 'abd', title: '123'

    #Not sure what to write here since display thing
  end
end
