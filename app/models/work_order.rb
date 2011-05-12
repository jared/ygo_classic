class WorkOrder < ActiveRecord::Base
  
  belongs_to :car
  
  has_many :line_items
  
  # attr_protected :car_id
  
  validates_presence_of :mileage, :date, :car_id
  
  def mileage=(miles)
    write_attribute(:mileage, miles.to_s.gsub(/[^\d]/, "").to_i)
  end
  
  def total_cost=(cost)
    write_attribute(:total_cost, cost.to_s.gsub(/[^\d\.]/,"").to_f)
  end
  
end
