class User < ActiveRecord::Base
  require 'pry'
  has_many :songs #, dependent: :destroy
  has_many :votes

  validates :name, presence: true
  validates :email, uniqueness: true
  # ... others?
  after_initialize :defaults

  def defaults
    self.avatar_url ||= "http://www.medgadget.com/wp-content/uploads/2013/05/Iron-Yard.png"
    self.favorite_song_url ||= "spotify:track:2b7FqlHc3JrzlYtGEkzq22"
    self.bio ||= "Member of The IronYard D.C."
  end

  def addsong spotify_id
    song = Spotify.find_song spotify_id 
      if song
        artist = song[:artist]
        track = song[:track_name]
        preview_link = song[:preview_link]
        play_link = song[:play_link]
        # User spends vote here
        Song.create!(title: track, artist: artist, spotify_id: spotify_id, user_id: self.id, preview_link: preview_link, play_link: play_link)
      else
        false
      end
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

  def welcome_email
    {
        :subject => "Hello from Spotibetical",
        :from_name => "Spotibetical Team",
        :text => "Hi! You should play our game. Your username is #{name}. Your current password is #{password}. Log in and change it because security. Enjoy the tunes!",
        :to => [{:email=> "#{email}", :name => "#{name}"}],
        :from_email=>"CHANGE@THIS.com" #UPDATE THIS EMAIL BEFORE USE
        }
  end
end