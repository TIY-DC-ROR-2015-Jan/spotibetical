class EditOutSpotLink < ActiveRecord::Migration
  def change
    remove_column :songs, :spotify_link
  end
end
