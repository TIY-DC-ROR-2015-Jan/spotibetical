class  Spot
require 'httparty'

  def self.find_song spotify_uri
    HTTParty.get("https://api.spotify.com/v1/tracks/#{spotify_uri}")
  end

  def self.refresh_access_token refresh_token
    response = HTTParty.post("https://accounts.spotify.com/api/token", {
      body: {
        grant_type:    "refresh_token",
        refresh_token: refresh_token,
        client_id:     ENV.fetch("SPOTIFY_ID"),
        client_secret: ENV.fetch("SPOTIFY_SECRET")
      }
    })
    raise "Refresh error: #{response}" unless response.ok?
    response
  end

  def self.access_token
    t = SpotifyAccessToken.last
    t.refresh! if t.expired?
    t.access_token
  end
end
