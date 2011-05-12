require 'test_helper'
require 'mocha'

class SessionsControllerTest < ActionController::TestCase

  def setup
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_login_and_redirect
    post :create, :login => 'jared', :password => 'test'
    assert session[:user]
    assert_response :redirect
  end

  def test_should_fail_login_and_not_redirect
    post :create, :login => 'jared', :password => 'bad password'
    assert_nil session[:user]
    assert_response :success
  end

  def test_should_logout
    login_as :jared
    get :destroy
    assert_nil session[:user]
    assert_response :redirect
  end

  def test_should_remember_me
    post :create, :login => 'jared', :password => 'test', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

  def test_should_not_remember_me
    post :create, :login => 'jared', :password => 'test', :remember_me => "0"
    assert_nil @response.cookies["auth_token"]
  end
  
  def test_should_delete_token_on_logout
    login_as :jared
    get :destroy
    assert_equal @response.cookies["auth_token"], nil
  end

  def test_should_login_with_cookie
    users(:jared).remember_me
    @request.cookies["auth_token"] = cookie_for(:jared)
    get :new
    assert @controller.send(:logged_in?)
  end

  def test_should_fail_expired_cookie_login
    users(:jared).remember_me
    users(:jared).update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(:jared)
    get :new
    assert !@controller.send(:logged_in?)
  end

  def test_should_fail_cookie_login
    users(:jared).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    assert !@controller.send(:logged_in?)
  end
    
  def test_open_id_login_problem_cases
    open_id_responses = {
      :missing    => "Sorry, the OpenID server couldn't be found",
      :canceled   => "OpenID verification was canceled",
      :failed     => "Sorry, the OpenID verification failed"
    }.each do |status, message|
      OpenIdAuthentication::Result.any_instance.expects(:code).returns(status)
      post :create, :openid_url => "http://sammyw.clearlyphonyopenidserver.net/"
      assert_equal flash[:error], message
    end
  end
  
  def test_open_id_login_fails_when_not_using_properly_formatted_openid
    post :create, :openid_url => "bad@open.id"
    assert_response :success
    assert_template 'new'
    deny flash[:error].empty?, "Flash error should not be empty."
  end
    
  # def test_open_id_login_fail_because_user_cannot_be_saved
  #   sreg = { 'nickname' => "Sammy", 'email' => "sammy@example.com"}
  #   open_id_response = mock
  #   open_id_response.expects(:status).returns(OpenID::Consumer::SUCCESS)
  #   open_id_response.expects(:identity_url).at_least(2).returns("http://sammyw.clearlyphonyopenidserver.net/")
  #   open_id_response.expects(:extension_response).with('sreg').returns(sreg)
  #   open_id_response.stubs(:endpoint => stub(:claimed_id => "http://sammyw.clearlyphonyopenidserver.net/"))
  #   open_id_response.stubs(:message).returns(stub(:namespaces => ""))
  #   
  #   User.any_instance.expects(:save).returns(false)
  #   
  #   @controller.stubs(:open_id_consumer).returns(stub(:complete => open_id_response))
  #   get :create, :openid_url => "http://sammyw.clearlyphonyopenidserver.net/", :open_id_complete => true
  # 
  #   assert_response :success
  #   assert_template 'new'
  # end
  # 
  # def test_open_id_login_success
  #   sreg = { 'nickname' => "Sammy", 'email' => "sammy@example.com"}
  #   open_id_response = mock
  #   open_id_response.expects(:status).returns(OpenID::Consumer::SUCCESS)
  #   open_id_response.expects(:identity_url).at_least(2).returns("http://sammyw.clearlyphonyopenidserver.net/")
  #   open_id_response.expects(:extension_response).with('sreg').returns(sreg)
  #   
  #   @controller.stubs(:open_id_consumer).returns(stub(:complete => open_id_response))
  #   get :create, :openid_url => "http://sammyw.clearlyphonyopenidserver.net/", :open_id_complete => true
  # 
  #   assert_redirected_to cars_path
  # end
  # 
  # def test_open_id_login_success_without_sreg
  #   sreg = { }
  #   open_id_response = mock
  #   open_id_response.expects(:status).returns(OpenID::Consumer::SUCCESS)
  #   open_id_response.expects(:identity_url).at_least(2).returns("http://sammyw.clearlyphonyopenidserver.net/")
  #   open_id_response.expects(:extension_response).with('sreg').returns(sreg)
  # 
  #   users(:sam).update_attribute(:display_name, nil)
  #   users(:sam).update_attribute(:email, nil)
  # 
  #   @controller.stubs(:open_id_consumer).returns(stub(:complete => open_id_response))
  #   get :create, :openid_url => "http://sammyw.clearlyphonyopenidserver.net/", :open_id_complete => true
  #   
  #   assert_redirected_to edit_user_path
  # end
  
protected
  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end
  
  def cookie_for(user)
    auth_token users(user).remember_token
  end
end
