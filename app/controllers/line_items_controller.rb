class LineItemsController < ApplicationController
  
  before_filter :login_required, :expose_models
  layout false
  
  def create
    @line_item = @work_order.line_items.build(params[:line_item])
    @line_item.save!
    respond_to do |format|
      format.html { redirect_to edit_car_work_order_path(@work_order.car, @work_order) }
      format.js   do
        render :update do |page|
          page.insert_html :top, 'line_items', :partial => 'line_item', :locals => { :line_item => @line_item }
          page["#{dom_id(@line_item)}"].visual_effect :highlight
          page['line_item_form'].reset
        end
      end
    end
    
  rescue ActiveRecord::RecordInvalid => e
    @line_item.valid?
    render :update do |page|
      page.alert("The following errors prevented the item from being added:\n" +
                  @line_item.errors.full_messages.join("\n") +".")    
    end
  end
  
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to edit_car_work_order_path(@work_order.car, @work_order) }
      format.js   do
        render :update do |page|
          page.remove dom_id(@line_item)
        end
      end
    end
  end
    
private

  def expose_models
    @work_order = WorkOrder.find(params[:work_order_id])
    @line_item = @work_order.line_items.find(params[:id]) unless params[:id].blank?
  end

end
