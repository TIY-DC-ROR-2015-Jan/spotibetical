class User < ActiveRecord::Base
  has_many :songs #, dependent: :destroy
  has_many :votes

  validates :name, presence: true
  validates :email, uniqueness: true
  # ... others?
end