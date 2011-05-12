require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  
  def setup
    @controller = LineItemsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @work_order = work_orders(:boogedy_service_1)
    login_as(:jared)
  end

  def test_should_create_line_item_via_xhr
    assert_difference 'LineItem.count' do
      xhr :post, :create, :line_item => { :description => "Oil Change" }, :work_order_id => @work_order.id
      assert_response :success
    end
  end
  
  def test_should_fail_to_create_line_item_via_xhr
    assert_no_difference 'LineItem.count' do
      xhr :post, :create, :line_item => { }, :work_order_id => @work_order.id
      assert_response :success
    end
  end
  
  def test_should_destroy_line_item_via_xhr
    assert_difference 'LineItem.count', -1 do
      xhr :delete, :destroy, :id => 1, :work_order_id => @work_order.id
      assert_response :success
    end
  end
  
end
