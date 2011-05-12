class CreateCars < ActiveRecord::Migration
  def self.up
    create_table :cars do |t|
      t.string :make, :model, :color, :null => false
      t.string :license_plate, :registration_state, :vehicle_identification_number
      t.integer :year, :user_id
      t.text :notes
    end
  end

  def self.down
    drop_table :cars
  end
end
