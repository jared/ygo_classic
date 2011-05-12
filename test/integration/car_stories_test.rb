require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/profile_helper"

class CarStoriesTest < ActionController::IntegrationTest
  

  include ProfileHelper
  
  def test_new_user_creates_new_car
    dawn = new_session { |user| user.extend(GarageExtensions) }
    dawn.get new_user_path
    dawn.is_viewing('new')
    dawn.creates_a_new_account @@user_default_values
    dawn.registers_a_car
  end
  
  def test_existing_user_creates_new_car
    jared = new_session { |user| user.extend(GarageExtensions) }
    jared.logs_in_as users(:jared)
    jared.is_redirected_to cars_path
    jared.registers_a_car
  end

private
  module GarageExtensions
    
    CAR_VALUES = {
      :make   => 'DeLorean',
      :model  => 'DMC-12',
      :year   => 1982,
      :color  => 'Stainless Steel'
    }
    
    def registers_a_car
      post_via_redirect cars_path, :car => CAR_VALUES
      is_viewing('show')
    end
    
  end

end
