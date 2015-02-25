require 'httparty'
class  Spot


  spotify_client_id = "id1"
  spotify_secret_id = "id2"
  spotify_authorization = "id3"

  def self.find_song spotify_uri
    HTTParty.get("https://api.spotify.com/v1/tracks/#{spotify_uri}")
  end


  def self.create_spotify_playlist authorization
    HTTParty.post("https://api.spotify.com/v1/users/dcironyard/playlists", 
      headers: {'Authorization' => "Bearer #{authorization}",
                'Content-Type' => 'application/json'},
      body:    {'name' =>'test', 
                'public' => 'true'})
  end

  def self.add_tracks_to_spotify playlist_id, spotify_uris, authorization
    binding.pry
    HTTParty.post("https://api.spotify.com/v1/users/dcironyard/playlists/#{playlist_id}/tracks", 
                  header:{'Authorization' => "Bearer #{authorization}",
                  'Content-Type' => 'application/json'},
                  body: {"uris" => spotify_uris})
  end
end
