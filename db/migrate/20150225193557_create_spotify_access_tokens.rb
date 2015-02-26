class CreateSpotifyAccessTokens < ActiveRecord::Migration
  def change
    create_table :spotify_access_tokens do |t|
      t.string   :access_token,  null: false
      t.string   :refresh_token, null: false
      t.datetime :expires_at,    null: false
    end
  end
end
