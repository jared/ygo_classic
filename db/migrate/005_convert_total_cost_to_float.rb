class ConvertTotalCostToFloat < ActiveRecord::Migration
  def self.up
    WorkOrder.find(:all).each do |work_order| 
      unless work_order.total_cost.nil?
        decimal_cost = work_order.total_cost.gsub(/[^0-9\.]/,'').to_f
        work_order.update_attribute(:total_cost, decimal_cost)
      end
    end
    change_column :work_orders, :total_cost, :decimal, :precision => 6, :scale => 2
  end

  def self.down
    change_column :work_orders, :total_cost, :string
  end
end
