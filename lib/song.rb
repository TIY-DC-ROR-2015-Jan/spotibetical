class Song < ActiveRecord::Base
  belongs_to :user

  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

  def self.sort_limit
    15
  end

  def self.artist_order#(limit)
    Song.order(artist: :asc).first self.sort_limit
  end

  def self.most_recent#(limit)
    Song.order(id: :desc).first self.sort_limit
  end

end