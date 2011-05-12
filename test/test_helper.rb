ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'mocha'

class ActiveSupport::TestCase
  include AuthenticatedTestHelper

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  fixtures :all

  # def self.all_fixtures
  #   # Dir["#{fixture_path}*.yml"].each {|f| fixtures File.basename(f, '.*').to_sym }
  #   fixtures :users, :cars, :work_orders, :line_items
  # end
  
  require 'test_rig'

  @@car_default_values = {
    :make   => 'DeLorean',
    :model  => 'DMC-12',
    :year   => 1982,
    :color  => 'Stainless Steel'
  }
  
  @@work_order_default_values = {
    :car_id  => 1,
    :date    => Date.new(2007, 5, 18),
    :mileage => 138000,
    :shop    => "Cricket",
    :notes   => "Routine Maintenance"
  }
  
  @@user_default_values = {
    :login  => 'dawn',
    :email  => 'dawn@example.com',
    :password => 'secret',
    :password_confirmation => 'secret',
    :receive_email => true,
    :accept_terms => 1
  }

end
