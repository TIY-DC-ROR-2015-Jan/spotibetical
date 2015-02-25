class User < ActiveRecord::Base
  require 'pry'
  has_many :songs #, dependent: :destroy
  has_many :votes

  validates :name, presence: true
  validates :email, uniqueness: true
  # ... others?

  def addsong spotify_id
    song = Spotify.find_song spotify_id
    artist = song[:artist]
    track = song[:track_name]
    preview_link = song[:preview_link]
    play_link = song[:play_link]

    # User spends vote here
    Song.create!(title: track, artist: artist, spotify_id: spotify_id, user_id: self.id, preview_link: preview_link, play_link: play_link)
  end

  def vote song_array
    if self.vote_count >= song_array.count
      song_array.each do |song|
        self.votes.create!(song_id: song)
        self.vote_count -= 1
        self.save!
      end
    end
  end

  def veto! song_id
    if self.veto_count > 0
      Song.find(song_id).update(veto: true)
      self.veto_count -= 1
      self.save!
    end
  end
end