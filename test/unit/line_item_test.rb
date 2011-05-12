require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  include TestRig::Model

  valid_attributes :work_order_id => 1,
                   :description   => "Oil Change"
                   
  required_fields :work_order_id, :description

  fixtures :work_orders

  def setup
    @line_item = LineItem.new(valid_attributes)
    fail "Test line item invalid: #{@line_item.errors.full_messages}" unless @line_item.valid?
  end

end
