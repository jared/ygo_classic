class LineItem < ActiveRecord::Base
  
  REPAIR_TYPES = %w(Major Minor Routine)
  
  belongs_to :work_order
  
  # attr_protected :work_order_id
  
  validates_presence_of :work_order_id, :description
  
end
