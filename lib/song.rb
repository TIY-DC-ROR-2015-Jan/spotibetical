class Song < ActiveRecord::Base
  PAGE_SIZE = 12

  belongs_to :user

  has_many :votes
  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs
  
  validates :spotify_id, presence: true, uniqueness: true

  def self.unvetoed
    where(veto: false)
  end

  def self.artist_order(limit=nil)
    limit ||= PAGE_SIZE
    Song.order(artist: :asc).first limit
  end

  def self.most_recent(limit=nil)
    limit ||= PAGE_SIZE
    Song.order(created_at: :desc).first limit
  end

  def sort_letter
    # artist.sub(/^(a |an |the )/, '')[0]
    letter = if artist.downcase.start_with? "a "
      artist[2]
    elsif artist.downcase.start_with? "an "
      artist[3]
    elsif artist.downcase.start_with? "the "
      artist[4]
    else
      artist[0]
    end
    letter.upcase
  end
end
