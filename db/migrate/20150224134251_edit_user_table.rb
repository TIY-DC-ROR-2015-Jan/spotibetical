class EditUserTable < ActiveRecord::Migration
  def change
    add_column :users, :vote_count, :integer, default: 10
  end
end
