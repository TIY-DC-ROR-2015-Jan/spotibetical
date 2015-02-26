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
end
