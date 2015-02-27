require 'httparty'

class Spotify

  SPOTIFY_ACCOUNT='dcironyard'
  def self.header access_token
    header = {
      'Authorization' => "Bearer #{access_token}",
      'Content-Type'  => 'application/json'
      }
  end

  def self.find_song spotify_uri
    song = HTTParty.get("https://api.spotify.com/v1/tracks/#{spotify_uri}")   
    unless song["error"]      
      song_hash = {
        artist: song["artists"][0]["name"],
        track_name: song["name"],
        play_link: song["external_urls"]["spotify"],
        preview_link: song["preview_url"]
      }
    end
    #nil
  end


  def self.create_spotify_playlist playlist
    response = HTTParty.post("https://api.spotify.com/v1/users/#{SPOTIFY_ACCOUNT}/playlists", 
      headers: Spotify.header(Spotify.access_token),
      body:{'name' => playlist.name}.to_json)
    playlist.update(
      spotify_link: response['external_urls']['spotify'],
      spotify_id: response['id']
      )
  end

  def self.add_tracks_to_spotify playlist_spotify_id, spotify_uris
    HTTParty.post("https://api.spotify.com/v1/users/#{SPOTIFY_ACCOUNT}/playlists/#{playlist_spotify_id}/tracks", 
      headers: Spotify.header(Spotify.access_token),
      body:  {"uris" => spotify_uris}.to_json
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

  def self.get_playlists
    playlist_data = HTTParty.get("https://api.spotify.com/v1/users/#{SPOTIFY_ACCOUNT}/playlists",
      headers: {
        'Authorization' => "Bearer #{Spotify.access_token}",
        "Accept" => "application/json" 
      })
    playlists =[]
    playlist_data["items"].map do |p|
      playlists.push([p['name'], p['external_urls']['spotify']])
    end
    playlists
  end
end
