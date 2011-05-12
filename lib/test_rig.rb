# Copyright (c) 2007 The Pragmatic Studio
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class Test::Unit::TestCase
  
  def deny(condition, message)
    assert !condition, message
  end
    
  def assert_models_equal(expected_models, actual_models, message = nil)
    to_test_param = lambda { |r| "<#{r.class}:#{r.to_param}>" }
    full_message = build_message(message, "<?> expected but was\n<?>.\n", 
      expected_models.collect(&to_test_param), actual_models.collect(&to_test_param))
    assert_block(full_message) { expected_models == actual_models }
  end
  
  def assert_attribute_invalid(object, attribute)
    deny object.valid?
    assert object.errors.invalid?(attribute)
  end
  
  def assert_all_invalid(object, *vars)
    vars.each do |var|
      assert_attribute_invalid(object, var)
    end
  end
  
  def assert_all_assigned(*vars)
    vars.each do |var|
      assert assigns(var), "@#{var.to_s} was not assigned."
    end
  end
  
  
end

class Hash

  # Usage { :a => 1, :b => 2, :c => 3}.except(:a) -> { :b => 2, :c => 3}
  def except(*keys)    
    if Array === keys
      reject { |k,v| keys.include? k.to_sym }
    else
      reject { |k,v| keys == k  }
    end 
  end

  # Usage { :a => 1, :b => 2, :c => 3}.only(:a) -> {:a => 1}
  def only(*keys)
    if Array === keys
      reject { |k,v| !keys.include? k.to_sym }
    else
      reject { |k,v| keys != k  }
    end
  end
  
end

module TestRig

  # Adds generic CRUD test actions to the functional test.
  module Controller
  
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        if name.demodulize.to_s =~ /^(.*)ControllerTest$/
          model($1.singularize.constantize) rescue nil
        end
        self.test_valid_attributes = {} 
        self.test_invalid_attributes = {}
        self.test_fixture_record = :first
      end
      base.send :include, InstanceMethods
    end
    
    module ClassMethods
      
      attr_accessor :test_model
      attr_accessor :test_valid_attributes
      attr_accessor :test_invalid_attributes
      attr_accessor :test_fixture_record
      attr_accessor :singular_model_name
      attr_accessor :plural_model_name
      
      def model(model)
        # unless fixture_table_names.include?(model.to_s.pluralize.underscore)
        #   fixtures model.to_s.pluralize.underscore.to_sym
        # end
        self.test_model = model.to_s.camelize.constantize
        self.singular_model_name = model.to_s.underscore.to_sym
        self.plural_model_name = model.to_s.underscore.pluralize.to_sym
      end
      
      def valid_attributes(attributes)
        self.test_valid_attributes = attributes
      end
      
      def invalid_attributes(attributes)
        self.test_invalid_attributes = attributes
      end
      
      def fixture_record(record)
        self.test_fixture_record = record
      end
      
    end
    
    module InstanceMethods

      def test_get_index
        return unless has_action?(:index)
         
        get :index

        assert_response :success
        assert_template 'index'

        assert_not_nil assigns(self.class.plural_model_name)
      end
     
      def test_get_show
        return unless has_action?(:show)
       
        get :show, :id => fixture_record_id
        
        assert_response :success
        assert_template 'show'

        ivar = self.class.singular_model_name
        assert_not_nil assigns(ivar)
        assert assigns(ivar).valid?, assigns(ivar).errors.full_messages
      end
     
      def test_get_new
        return unless has_action?(:new)
       
        get :new

        assert_response :success
        assert_template 'new'

        assert_not_nil assigns(self.class.singular_model_name)
      end
     
      def test_create
        return unless has_action?(:create)
       
        assert_difference "#{self.class.test_model}.count", 1 do
          post :create, self.class.singular_model_name => valid_attributes

          assert_response :redirect
          assert_redirected_to :action => :index
        end
      end
     
      def test_should_not_create_with_invalid_attributes
        return unless has_action?(:create) && invalid_attributes.any?
       
        assert_difference "#{self.class.test_model}.count", 0 do
          post :create, self.class.singular_model_name => invalid_attributes

          assert_response :success
          assert_template 'new'
        end
      end
     
      def test_get_edit
        return unless has_action?(:edit)

        get :edit, :id => fixture_record_id
       
        assert_response :success
        assert_template 'edit'

        ivar = self.class.singular_model_name
        assert_not_nil assigns(ivar)
        assert assigns(ivar).valid?, assigns(ivar).errors.full_messages
      end
     
      def test_update
        return unless has_action?(:update)
       
        post :update, :id => fixture_record_id, 
                       self.class.singular_model_name => valid_attributes

        assert_response :redirect 
        assert_redirected_to :action => :show, :id => fixture_record_id
      end
      
      def test_should_not_update_with_invalid_attributes
        return unless has_action?(:update) && invalid_attributes.any?
       
        post :update, :id => fixture_record_id, 
                      self.class.singular_model_name => invalid_attributes

        assert_response :success
        assert_template 'edit'
      end
     
      def test_destroy
        return unless has_action?(:destroy)
       
        assert_nothing_raised {
          self.class.test_model.find(fixture_record_id)
        }

        post :destroy, :id => fixture_record_id
       
        assert_response :redirect
        assert_redirected_to :action => :index

        assert_raise(ActiveRecord::RecordNotFound) {
          self.class.test_model.find(fixture_record_id)
        }
      end
     
      def test_get_search
        return unless has_action?(:search)
       
        ['', 'foobarbaz'].each do |term|
          get :search, :term => term
       
          assert_response :success
          assert_template 'index'

          assert_not_nil assigns(self.class.plural_model_name)
        end
      end
     
      protected

      def valid_attributes
        self.class.test_valid_attributes
      end
      
      def invalid_attributes
        self.class.test_invalid_attributes
      end
      
      def fixture_record_id
        send(self.class.plural_model_name, self.class.test_fixture_record).id 
      end

      def has_action?(method)
        @controller.respond_to?(method)
      end
    
    end
  end
  
  # Adds generic CRUD test actions to the unit test.
  module Model
    
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        if name.to_s =~ /^(.*)Test$/
          model($1)
        end
        self.test_valid_attributes = {} 
        self.test_required_fields = []
        self.test_unique_fields = []
        self.test_protected_fields = []
      end
      base.send :include, InstanceMethods
    end
    
    module ClassMethods
      
      attr_accessor :test_model
      attr_accessor :test_valid_attributes
      attr_accessor :test_required_fields
      attr_accessor :test_unique_fields
      attr_accessor :test_protected_fields
      
      def model(model)
        # unless fixture_table_names.include?(model.to_s.pluralize.underscore)
        #   fixtures model.to_s.pluralize.underscore.to_sym
        # end
        self.test_model = model.to_s.camelize.constantize
      end

      def valid_attributes(attributes)
        self.test_valid_attributes = attributes
      end
      
      def required_fields(*fields)
        self.test_required_fields = fields
      end
      
      def unique_fields(*fields)
        self.test_unique_fields = fields
      end
      
      def protected_fields(*fields)
        self.test_protected_fields = fields
      end

    end
    
    module InstanceMethods
            
      def test_create
        assert_difference "#{self.class.test_model}.count", 1 do
          should_save(valid_attributes)
        end
      end
      
      def test_should_be_invalid_without_required_fields 
        self.class.required_fields.each do |f|
          values = valid_attributes.except(f)
          should_be_invalid(values, "Valid without #{field}.") do |r|
            assert r.errors.invalid?(field)
          end
        end
      end
      
      def test_should_be_invalid_without_unique_fields
        return unless self.class.test_unique_fields.any?
        self.class.test_model.create(valid_attributes)
        should_be_invalid(valid_attributes) do |r|
          self.class.test_unique_fields.each do |f|
            assert r.errors.invalid?(f), "Valid with non-unique #{f}." 
          end
        end
      end
      
      protected
            
      def should_be_valid(data, msg=nil)
        model = new_model(data)
        assert model.valid?, msg || model.errors.full_messages
        yield model if block_given?
      end
      
      def should_be_invalid(data, msg=nil)
        model = new_model(data)
        deny model.valid?, msg || model.errors.full_messages
        yield model if block_given?
      end

      def should_save(data, msg=nil)
        model = new_model(data)
        assert model.save, msg || model.errors.full_messages
        yield model if block_given?
      end

      def should_not_save(data, msg=nil)
        model = new_model(data)
        deny model.save, msg || model.errors.full_messages
        yield model if block_given?
      end
            
      def new_model(data)
        model = self.class.test_model.new(data)
        write_protected_fields(model)
        model
      end
      
      def valid_attributes
        self.class.test_valid_attributes
      end
      
      def write_protected_fields(item)
        self.class.test_protected_fields.each do |f|
          item.send "#{f}=", self.class.test_protected_attributes[f]
        end
      end
    end
  end
end
