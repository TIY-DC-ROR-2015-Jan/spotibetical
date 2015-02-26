require 'dotenv'
# Loads in ENV variables from the (.gitignored) .env file
Dotenv.load

require "./db/setup"
require "./lib/all"

id, secret = ENV["SPOTIFY_ID"], ENV["SPOTIFY_SECRET"]
unless id && secret
  puts "Please set SPOTIFY_ID and SPOTIFY_SECRET"
  exit 1
end

puts <<INSTRUCTIONS
To obtain a Spotify token, please log in to Spotify in your browser and then
* visit 'https://accounts.spotify.com/authorize?response_type=code&redirect_uri=http://localhost:3000&scope=playlist-modify-public&client_id=#{id}'
* copy the `code` parameter from the response and paste it in now:
INSTRUCTIONS
code = gets.chomp

response = HTTParty.post 'https://accounts.spotify.com/api/token', body: {
  grant_type:    "authorization_code",
  redirect_uri:  "http://localhost:3000",
  code:          code,
  client_id:     id,
  client_secret: secret
}

unless response.ok?
  puts "Error: #{response}"
  exit 2
end

SpotifyAccessToken.create!(
  access_token:  response["access_token"],
  refresh_token: response["refresh_token"],
  expires_at:    Time.now + response["expires_in"]
)
puts "Your token has been created"
