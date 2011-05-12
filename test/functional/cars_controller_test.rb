# require File.dirname(__FILE__) + '/../test_helper'
# require 'cars_controller'
require 'test_helper'
class CarsControllerTest < ActionController::TestCase
  include TestRig::Controller

  fixture_record :boogedy
  
  valid_attributes :make  => 'Delorean',
                   :model => 'DMC-12',
                   :year  => 1982,
                   :color => 'Stainless Steel',
                   :notes => 'Coolest car ever.',
                   :user_id => 1
                   
  invalid_attributes :make => nil
  
  def setup
    login_as(:jared)
  end

  def test_create
    assert_difference 'Car.count' do
      post :create, :car => valid_attributes
      assert_redirected_to car_path(assigns(:car))
    end
  end

end
