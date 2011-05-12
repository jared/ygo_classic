require 'test_helper'

class WorkOrdersControllerTest < ActionController::TestCase

  def setup
    @controller = WorkOrdersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @car        = cars(:boogedy)
    login_as(:jared)
  end
  
  def test_should_get_index
    get :index, :car_id => @car.id
    assert_response :success
    assert_equal @car.work_orders.size, assigns(:work_orders).size, "Should show all work orders for Car."
  end
  
  def test_should_get_index_via_xhr_for_query
    xhr :get, :index, :query => "air", :car_id => @car.id
    assert_response :success
    assert_equal 1, assigns(:work_orders).size, "Should only show one work order."
  end
  
  def test_should_get_new
    get :new, :car_id => @car.id
    assert_response :success
  end
  
  def test_should_create_work_order
    assert_difference 'WorkOrder.count' do
      post :create, :work_order => @@work_order_default_values, :car_id => @car.id
      assert_redirected_to edit_car_work_order_path(@car, assigns(:work_order))
    end
  end
  
  def test_should_find_shop_via_xhr
    xhr :post, :auto_complete_for_work_order_shop, :car_id => @car.id, :work_order => { :shop => 'cri' }
    assert_response :success
    assigns(:items).all? { |item| assert_match(/Cricket/, item.shop) }
  end
  
  def test_should_fail_to_create_work_order
    assert_no_difference 'WorkOrder.count' do
      post :create, :work_order => { }, :car_id => @car.id
      assert_response :success
    end
  end
  
  def test_should_show_work_order
    get :show, :id => 1, :car_id => @car.id
    assert_response :success
  end
  
  def test_should_get_edit
    get :edit, :id => 1, :car_id => @car.id
    assert_response :success
  end
  
  def test_should_update_work_order
    put :update, :id => 1, :work_order => { }, :car_id => @car.id
    assert_redirected_to car_work_order_path(assigns(:car), assigns(:work_order))
  end
  
  def test_should_fail_to_update_work_order
    put :update, :id => 1, :work_order => { :date => nil }, :car_id => @car.id
    assert_response :success
  end
  
  def test_should_update_work_order_via_xhr
    xhr :put, :update, :id => 1, :work_order => { :total_cost => 500.00 }, :car_id => @car.id
    assert_response :success
  end
  
  def test_should_destroy_work_order
    assert_difference 'WorkOrder.count', -1 do
      delete :destroy, :id => 1, :car_id => @car.id
      assert_redirected_to car_work_orders_path(@car)
    end
  end
  
end
