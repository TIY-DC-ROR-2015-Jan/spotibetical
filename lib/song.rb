class Song < ActiveRecord::Base
  belongs_to :user

  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

  validates :spotify_id, presence: true
end