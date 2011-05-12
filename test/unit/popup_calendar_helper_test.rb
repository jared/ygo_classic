require 'test_helper'

class PopupCalendarHelperTest < ActiveSupport::TestCase
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::PrototypeHelper
  include ActionView::Helpers::ScriptaculousHelper
  include PopupCalendarHelper
  
  def setup
    @controller = WorkOrdersController.new
    request     = ActionController::TestRequest.new
    @controller.instance_eval { @params = {}, @request = request }
    # @controller.send(:initialize_current_url)
  end
  
  def test_popup_calendar_helper
    { "date" => "%Y-%m-%d", "datetime" => "%Y-%m-%d %I:%M %p", "%Y" => "%Y" }.each do |key, format|
      assert_match(/ifFormat:'#{format}'/, popup_calendar_tag('work_order_date', :format => key))
    end
  end
  
end