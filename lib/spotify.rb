require 'httparty'
class  Spot

  def self.find_song spotify_uri
    HTTParty.get("https://api.spotify.com/v1/tracks/#{spotify_uri}")
  end

  def self.create_spotify_playlist name
    HTTParty.post("https://api.spotify.com/v1/users/dcironyard/playlists", 
      headers: {'Authorization' => "Bearer #{Spot.access_token}",
      'Content-Type'  => 'application/json'},
      body:    {'name'   => name, 
        'public' => 'true'})
  end

  def self.add_tracks_to_spotify playlist_name, spotify_uris
    HTTParty.post("https://api.spotify.com/v1/users/dcironyard/playlists/#{playlist_name}/tracks", 
      header:{'Authorization' => "Bearer #{Spot.access_token}",
      'Content-Type'  => 'application/json'},
      body:  {"uris" => spotify_uris})
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
