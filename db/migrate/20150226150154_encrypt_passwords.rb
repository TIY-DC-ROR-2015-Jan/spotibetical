class EncryptPasswords < ActiveRecord::Migration
  def change
    User.find_each do |u|
      u.password = Digest::SHA1.hexdigest(u.password)
      u.save!
    end
  end
end
