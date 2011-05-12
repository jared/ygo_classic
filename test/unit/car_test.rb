require 'test_helper'

class CarTest < ActiveSupport::TestCase
  include TestRig::Model

  valid_attributes :make  => 'Delorean',
                   :model => 'DMC-12',
                   :year  => 1982,
                   :color => 'Stainless Steel',
                   :notes => 'Coolest car ever.',
                   :user_id => 1
                   
  required_fields :make, :model, :year, :user_id

  def setup
    @car = Car.new(valid_attributes)
    fail "Test car invalid: #{@car.errors.full_messages}" unless @car.valid?
  end
  
  def test_car_name
    assert_equal "1982 Delorean DMC-12", @car.name, "Car should have a name based on user, year, make and model."
  end
  
  def test_short_name_with_long_make
    assert_equal "1982 Delo DMC-12", @car.short_name, "Car short name should truncate make if longer than six characters."
  end
  
  def test_short_name_with_short_make
    @car.make = "Honda"
    assert_equal "1982 Honda DMC-12", @car.short_name, "Car short name should not truncate if length is less than six characters."
  end
  
  def test_should_find_random_car
    @car = Car.find(:random)
    assert_not_nil @car, "Should have found one random car."
  end

end
