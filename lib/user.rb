class User < ActiveRecord::Base
  has_many :songs #, dependent: :destroy
  has_many :votes

  validates :name, presence: true
  validates :email, uniqueness: true
  # ... others?

  def vote song_array
    if self.vote_count >= song_array.count
      song_array.each do |song|
        self.votes.create!(song_id: song)
        self.vote_count -= 1
        self.save!
      end
    end
  end
end