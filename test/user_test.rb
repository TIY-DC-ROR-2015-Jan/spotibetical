require './test/helper'

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
end