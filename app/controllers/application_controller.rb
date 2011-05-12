# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable

  filter_parameter_logging :email, :password, :vin

  before_filter :login_from_cookie

  class <<self
    def auto_complete_for(object, method, options={})
      define_method("auto_complete_for_#{object}_#{method}") do
        find_options = {
          :conditions => [ "LOWER(#{method}) LIKE ?", '%' + params[object][method].downcase + '%'],
          :order      => "#{method} ASC",
          :limit      => 10 
        }.merge!(options)
      
        @items = current_user.send(object.to_s.tableize).find(:all, find_options)
      
        render :inline => "<%= auto_complete_result @items, '#{method}' %>"
      end
    end
  end

end
