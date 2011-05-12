class CreateWorkOrders < ActiveRecord::Migration
  def self.up
    create_table :work_orders do |t|
      t.integer :car_id, :mileage
      t.string  :shop, :total_cost
      t.date    :date
      t.text    :notes
    end
  end

  def self.down
    drop_table :work_orders
  end
end
