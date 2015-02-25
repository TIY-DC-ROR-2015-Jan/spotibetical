class Spotify
require 'httparty'
require 'pry'

  def self.find_song spotify_uri
    song = HTTParty.get("https://api.spotify.com/v1/tracks/#{spotify_uri}")
    song_hash = {
      artist: song["artists"][0]["name"],
      track_name: song["name"],
      play_link: song["external_urls"]["spotify"],
      preview_link: song["preview_url"]
    }
  end

end