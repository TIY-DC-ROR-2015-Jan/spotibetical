require './test/helper'
require './spotibetical'

require 'rack/test'
require 'pry'

class UserTest < MiniTest::Test
  include Rack::Test::Methods
  def app
    Spotibetical
  end
  def setup
    User.delete_all
    Song.delete_all

    # [User, Song].each &:delete_all
  end

  def test_users_can_have_songs

    u = User.create! name: 'Brit Butler', email: 'brit@kingcons.io', password: 'password'
    s = Song.create! artist: 'The Faint', title: 'Dress Code', user_id: 1, spotify_id: '-'
    u.songs.push s
    # playlist.songs.push s

    loaded_user = User.find u.id
    assert_equal loaded_user.songs.first.title, "Dress Code"
  end

  def test_songs_save_vote_counts
    u = User.create! name: 'Brit Butler', email: 'brit@kingcons.io', password: 'password'
    s = Song.create! artist: 'The Faint', title: 'Dress Code', user_id: 1, spotify_id: '-'
    Vote.create!(song_id: s.id, user_id: u.id)
    assert_equal s.votes.count, 1
  end

  def test_vote_count_decreases_after_vote
    u = User.create! name: 'Brit Butler', email: 'brit@kingcons.io', password: 'password'
    s = Song.create! artist: 'The Faint', title: 'Dress Code', user_id: 1, spotify_id: '-'
    u.votes.create!(song_id: s.id)
    u.vote_count -= 1
    u.save!
    assert u.vote_count < 10
  end

  def test_user_cannot_vote_more_than_vote_count
    u = User.create! name: 'Brit Butler', email: 'brit@kingcons.io', password: 'password'
    s = Song.create! artist: 'The Faint', title: 'Dress Code', user_id: 1, spotify_id: '-'
    u.vote_count = 1
    u.vote [s.id, s.id]
    assert_equal s.votes.count, 0
  end

  def test_vote_handler_works
    u = User.create! name: 'Brit Butler', email: 'brit@kingcons.io', password: 'password'
    s = Song.create! artist: 'The Faint', title: 'Dress Code', user_id: 1, spotify_id: '-'
    post '/users/login', email: 'brit@kingcons.io', password: 'password'
    patch '/vote', songs: [s.id]
    assert_equal s.votes.count, 1
  end

  def test_veto_handler_works
    u = User.create! name: 'Brit Butler', email: 'brit@kingcons.io', password: 'password'
    s = Song.create! artist: 'The Faint', title: 'Dress Code', user_id: 1, spotify_id: '-'
    post '/users/login', email: 'brit@kingcons.io', password: 'password'
    patch '/veto', song_id: s.id
    assert_equal Song.find(s.id).veto, true
  end
end
