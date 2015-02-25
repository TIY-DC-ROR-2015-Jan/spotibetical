class Song < ActiveRecord::Base
  PAGE_SIZE = 12

  belongs_to :user

  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

  def self.artist_order(limit=PAGE_SIZE)
    Song.order(artist: :asc).first limit
  end

  def self.most_recent(limit=PAGE_SIZE)
    Song.order(created_at: :desc).first limit
  end

end