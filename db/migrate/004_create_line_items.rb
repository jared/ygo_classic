class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.integer :work_order_id
      t.string  :description
    end
  end

  def self.down
    drop_table :line_items
  end
end
