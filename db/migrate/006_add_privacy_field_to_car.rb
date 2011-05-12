class AddPrivacyFieldToCar < ActiveRecord::Migration
  def self.up
    add_column :cars, :private, :boolean
    Car.update_all "private = 0"
  end

  def self.down
    remove_column :cars, :private
  end
end
