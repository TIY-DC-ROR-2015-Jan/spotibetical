class AddProfileFieldsToUsers < ActiveRecord::Migration
  # t.string :avatar_url
  # t.text   :bio
  # t.string :home_state
  # t.string :zodiac_sign
  # t.string :favorite_song_url
  def change
    add_column :users, :avatar_url, :string
    add_column :users, :bio, :text
    add_column :users, :home_state, :string
    add_column :users, :zodiac_sign, :string
    add_column :users, :favorite_song_url, :string
  end
end
