require './test/helper'

require 'rack/test'
require './spotibetical'

class UserAuthTest < MiniTest::Test
  # We need the following to enable the `get`, `post`, `delete` and
  #   `last_response` methods used in these tests
  include Rack::Test::Methods
  def app
    # Note that we needed to include the app so we can write tests about it,
    #   hence the added `$PROGRAM_NAME == __FILE__` check there
    Spotibetical
  end

  def setup
    super
    User.create! email: 'brit@kingcons.io', password: 'hunter2', name: 'Brit Butler'
  end

  def test_users_can_login
    # We aren't logged in to start with (see a login button)
    get '/'
    assert last_response.body.include? "Login"
    refute last_response.body.include? "Logout"

    # We got to login and can login
    post '/users/login', email: 'brit@kingcons.io', password: 'hunter2'
    assert last_response.redirect?

    # Now we should be logged in (see logout button)
    get '/'
    assert_equal last_response.status, 200
    refute last_response.body.include? "Login"
    assert last_response.body.include? "Logout"
  end

  def test_login_for_redisplays_on_error
    post '/users/login', email: 'jamesdabbs@gmail.com', password: 'password'
    assert_equal last_response.status, 422 # This is the 'right' status code for invalid
    assert last_response.body.include? "Wrong!"
  end

  def test_users_can_logout
    skip "Left as an exercise for the reader ..."
  end

  def test_before_filter 
    get '/users/profile'
    assert last_response.redirect?

    post '/add_song', spotify_id: "also random junk"
    assert last_response.redirect?

    post '/users/login', email: 'brit@kingcons.io', password: 'hunter2'
    get '/users/profile'
    assert_equal last_response.status, 200

    get '/add_song'
    assert_equal last_response.status, 200
  end
end
