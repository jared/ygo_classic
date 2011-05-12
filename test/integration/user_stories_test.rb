require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/profile_helper"

class UserStoriesTest < ActionController::IntegrationTest
  

  include ProfileHelper
  
  def test_creating_a_user
    dawn = new_session
    dawn.get new_user_path
    dawn.is_viewing('new')
    dawn.creates_a_new_account @@user_default_values
  end
  
  def test_sign_in_and_view_garage
    jared = new_session
    jared.logs_in_as users(:jared)
    jared.is_redirected_to cars_path
    jared.logs_out
  end
  
end
