class ModifyPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :name, :string
    add_column :playlists, :spotify_id, :string
  end
end
