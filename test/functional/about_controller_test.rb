require 'test_helper'

class AboutControllerTest < ActionController::TestCase
  
  def setup
    @controller = AboutController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_home_url
    get :home
    assert_template 'home'
  end
  
  def test_should_get_about_url
    get :index
    assert_template 'index'
  end
  
  def test_should_get_privacy_url
    get :privacy
    assert_template 'privacy'
  end
  
  def test_should_get_terms_url
    get :tos
    assert_template 'tos'
  end
  
end
