class AddLinkToSongTable < ActiveRecord::Migration
  def change
    add_column :songs, :play_link, :string
    add_column :songs, :preview_link, :string
  end
end
