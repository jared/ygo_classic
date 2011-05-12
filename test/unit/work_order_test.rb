require 'test_helper'

class WorkOrderTest < ActiveSupport::TestCase
  include TestRig::Model

  valid_attributes :car_id      => 1,
                   :date        => Date.new(2007, 5, 18),
                   :mileage     => 138000,
                   :shop        => "Cricket",
                   :notes       => "Routine Maintenance",
                   :total_cost  => 400.00
                   
  required_fields :date, :mileage, :car_id
  
  def setup
    @work_order = WorkOrder.new(valid_attributes)
    fail "Test Work Order invalid: #{@work_order.errors.full_messages}" unless @work_order.valid?
  end
  
end
