class AddPrivacySettingsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :receive_email, :boolean
    User.update_all "receive_email = 1"
  end

  def self.down
    remove_column :users, :receive_email
  end
end
