class Song < ActiveRecord::Base
  belongs_to :user

  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

  def self.get_artist_letter song_list
    songs_by_artist = {}
    #letters = []
    song_list.each do |song|
      songs_by_artist[song.artist.chr] = song
      #binding.pry
    end
    
    return songs_by_artist

    
  end

end