require 'test_helper'

class ShowroomsControllerTest < ActionController::TestCase

  def test_should_get_show
    get :show, :id => cars(:boogedy).id
    assert_response :success
    assert assigns(:featured_car)
  end
  
  def test_should_fail_to_show_private_car
    get :show, :id => cars(:impala).id
    assert_redirected_to home_url
  end
end
