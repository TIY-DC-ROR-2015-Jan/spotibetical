require './test/helper'

class PlaylistTest < MiniTest::Test
  def setup
    Song.delete_all
    Vote.delete_all
    Playlist.delete_all
    User.delete_all
  end

  def test_it_can_create_from_votes
    # Create some songs
    a1, a2, b1, b2 = %w(a1 a2 b1 b2).map do |name|
      Song.create! artist: name, spotify_id: name, title: name, user_id: 1
    end

    u1, u2, u3 = %w(u1 u2 u3).map do |name|
      User.create! name: name, email: "#{name}@example.com", password: "password"
    end

    # Fake some votes
    # a1 - 2 votes
    # a2 - 1 vote
    # b1 - 2 votes, veto
    # b2 - 1 vote
    u1.vote [a1.id, b2.id]
    u2.vote [a1.id, b1.id]
    u3.vote [a2.id, b1.id]
    u1.veto! b1.id

    # Generate playlist
    playlist = Playlist.generate_for_week!
    
    # Make sure that worked
    assert_equal playlist.songs, [a1, b2]
  end

  def test_the_pogues
    a = Song.create! artist: 'The Pogues', title: 'Something long', spotify_id: '-', user_id: 1
    b = Song.create! artist: 'Punch Brothers', title: 'Rye Whiskey', spotify_id: '--', user_id: 1
    u = User.create! name: 'a', email: 'a@example.com', password: 'password'
    u.vote [a.id, b.id]

    playlist = Playlist.generate_for_week!
    assert_equal playlist.songs.count, 1
  end
end