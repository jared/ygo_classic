class AddIndexesToDatabase < ActiveRecord::Migration
  def self.up
    add_index :cars, :user_id
    add_index :work_orders, :car_id
    add_index :work_orders, :shop
    add_index :line_items, :work_order_id
  end

  def self.down
    remove_index :cars, :user_id
    remove_index :work_orders, :car_id
    remove_index :work_orders, :shop
    remove_index :line_items, :work_order_id
  end
end
