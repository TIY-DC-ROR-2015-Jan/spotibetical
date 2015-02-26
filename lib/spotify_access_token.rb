class SpotifyAccessToken < ActiveRecord::Base
  def expired?
    expires_at < Time.now
  end

  def refresh!
    response = Spotify.refresh_access_token refresh_token
    update(
      access_token: response["access_token"],
      expires_at:   Time.now + response["expires_in"]
    )
  end
end
