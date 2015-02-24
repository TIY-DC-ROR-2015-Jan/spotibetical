require './test/helper'
require 'pry'

class UserTest < MiniTest::Test
  def setup
    User.delete_all
    Song.delete_all
    # [User, Song].each &:delete_all
  end

  def test_users_can_have_songs
    u = User.create! name: 'Brit Butler', email: 'brit@kingcons.io', password: 'password'
    s = Song.create! artist: 'The Faint', title: 'Dress Code', user_id: 1
    u.songs.push s
    # playlist.songs.push s

    loaded_user = User.find u.id
    assert_equal loaded_user.songs.first.title, "Dress Code"
  end

  def test_songs_save_vote_counts
    u = User.create! name: 'Brit Butler', email: 'brit@kingcons.io', password: 'password'
    s = Song.create! artist: 'The Faint', title: 'Dress Code', user_id: 1
    Vote.create!(song_id: s.id, user_id: u.id)
    assert_equal s.votes.count, 1
  end

  def test_vote_count_decreases_after_vote
    u = User.create! name: 'Brit Butler', email: 'brit@kingcons.io', password: 'password'
    s = Song.create! artist: 'The Faint', title: 'Dress Code', user_id: 1
    u.votes.create!(song_id: s.id)
    u.vote_count -= 1
    u.save!
    assert u.vote_count < 10
  end

  def test_user_cannot_vote_more_than_vote_count
    u = User.create! name: 'Brit Butler', email: 'brit@kingcons.io', password: 'password'
    s = Song.create! artist: 'The Faint', title: 'Dress Code', user_id: 1
    u.vote_count = 1
    u.vote [s.id, s.id]
    assert_equal s.votes.count, 0
  end
end