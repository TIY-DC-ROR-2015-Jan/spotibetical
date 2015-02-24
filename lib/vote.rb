class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :song

  # validates_uniqueness_of :user_id, scope: :song_id
end