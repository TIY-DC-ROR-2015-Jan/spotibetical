class EditUserAddVeto < ActiveRecord::Migration
  def change
    add_column :users, :veto_count, :integer, default: 1
  end
end
