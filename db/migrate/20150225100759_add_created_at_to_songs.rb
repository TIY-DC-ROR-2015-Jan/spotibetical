class AddCreatedAtToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :created_at, :datetime
  end
end
