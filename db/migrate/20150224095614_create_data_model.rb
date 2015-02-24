class CreateDataModel < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password, null: false
      t.string :name
    end

    create_table :songs do |t|
      t.string  :artist, null: false
      t.string  :title, null: false
      t.string  :spotify_link
      t.integer :user_id, null: false
    end

    create_table :playlists do |t|
      t.datetime :created_at
      t.string   :spotify_link
    end

    create_table :votes do |t|
      t.integer :user_id, null: false
      t.integer :song_id, null: false
    end

    create_table :playlist_songs do |t|
      t.integer :playlist_id, null: false
      t.integer :song_id, null: false
    end
  end
end
