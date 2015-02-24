class User < ActiveRecord::Base
  require 'pry'
  has_many :songs #, dependent: :destroy
  has_many :votes

  validates :name, presence: true
  validates :email, uniqueness: true
  # ... others?

  def addsong spotify_id
    #takes spotify ID, makes request to spotify which returns json object for the track
    #using that json object, fills in song artist/title/spotify_id
    song = Spot.find_song spotify_id
    artist = song["artists"][0]["name"]
    track = song["name"]
    Song.create!(title: track, artist: artist, spotify_id: spotify_id, user_id: self.id)
  end
end