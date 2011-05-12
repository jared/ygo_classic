require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/profile_helper"

class WorkOrderStoriesTest < ActionController::IntegrationTest
  

  include ProfileHelper
  
  def test_creating_a_work_order
    jared = new_session { |user| user.extend WorkOrderExtensions }
    jared.logs_in_as users(:jared)
    jared.is_redirected_to cars_path
    jared.selects_a_vehicle cars(:boogedy)
    jared.views_existing_work_orders cars(:boogedy)
    jared.search_work_orders_for_tire cars(:boogedy) 
    jared.creates_a_work_order cars(:boogedy) 
  end

private
  module WorkOrderExtensions
    
    WORK_ORDER_VALUES = {
      :date    => 1.week.ago.to_date,
      :mileage => 138000,
      :shop    => "Cricket",
      :notes   => "Routine Maintenance"
    }

    def selects_a_vehicle(car)
      get car_path(car)
      is_viewing('show')
    end
    
    def views_existing_work_orders(car)
      get car_work_orders_path(car)
      is_viewing('index')
    end
    
    def creates_a_work_order(car)
      post_via_redirect car_work_orders_path, :car_id => car.id, :work_order => WORK_ORDER_VALUES
      is_viewing('edit')
    end
    
    def search_work_orders_for_tire(car)
      xml_http_request :get, car_work_orders_path(car), :query => 'tire'
      assert_response :success
      assert_equal 1, assigns(:work_orders).size
    end

  end

end
