class Song < ActiveRecord::Base
  belongs_to :user

  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

  def self.artist_order(limit=nil)
    Song.order(artist: :asc).first 12
  end

  def self.most_recent(limit=nil)
    Song.order(id: :desc).first 12
  end

end