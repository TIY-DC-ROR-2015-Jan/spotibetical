class EditSongAddVeto < ActiveRecord::Migration
  def change
    add_column :songs, :veto, :boolean, default: false
  end
end
