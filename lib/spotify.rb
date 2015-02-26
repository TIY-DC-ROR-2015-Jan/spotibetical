require 'httparty'

class Spotify

  URI = 'https://api.spotify.com/v1'
  # @headers = {
  #   'Authorization' => "Bearer #{Spotify.access_token}",
  #   'Content-Type'  => 'application/json'
  # }

  def self.find_song spotify_uri
    song = HTTParty.get("#{URI}/tracks/#{spotify_uri}")
    song_hash = {
      artist: song["artists"][0]["name"],
      track_name: song["name"],
      play_link: song["external_urls"]["spotify"],
      preview_link: song["preview_url"]
    }
  end


  def self.create_spotify_playlist playlist
    response = HTTParty.post("#{URI}/users/dcironyard/playlists", 
      headers: {
        'Authorization' => "Bearer #{Spotify.access_token}",
        'Content-Type'  => 'application/json'
        },
        body:{
          'name' => playlist.name, 
          'public' => 'true'
          }.to_json
          )
    playlist.update(
      spotify_link: response['external_urls']['spotify'],
      spotify_id: response['id']
      )
  end

  def self.add_tracks_to_spotify playlist_spotify_id, spotify_uris
    HTTParty.post("#{URI}/users/dcironyard/playlists/#{playlist_spotify_id}/tracks", 
      headers: {
        'Authorization' => "Bearer #{Spotify.access_token}",
        'Content-Type'  => 'application/json'
        },
        body:  {"uris" => spotify_uris
          }.to_json
          )
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
