require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as(:jared)
  end
  
  def test_show_should_redirect_to_edit
    get :show
    assert_redirected_to edit_user_path
  end
  
  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_allow_signup
    assert_difference 'User.count' do
      create_user
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end
  
  def test_should_get_edit
    get :edit
    assert_equal assigns(:user).id, users(:jared).id
  end
  
  def test_should_update_user_account
    put :update, :user => { :login => 'stanley' }
    assert_redirected_to cars_url
  end
  
  def test_should_fail_to_update_user_account
    put :update, :user => { :login => nil }
    assert_response :success
  end

  protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :email => 'quire@example.com', 
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
