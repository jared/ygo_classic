class WorkOrdersController < ApplicationController
  before_filter :login_required, :expose_models
  layout 'work_order'
  helper 'popup_calendar'
  
  auto_complete_for :work_order, :shop

  # GET /work_orders
  # GET /work_orders.xml
  def index
    unless params[:query].blank?
      @work_orders = @car.work_orders.search(params[:query])
    else
      @work_orders = @car.work_orders.ordered
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.js do
        render :update do |page|
          page[:results].replace_html :partial => "work_order", :collection => @work_orders
        end
      end
      format.xml  { render :xml => @work_orders }
    end
  end

  # GET /work_orders/1
  # GET /work_orders/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @work_order }
    end
  end

  # GET /work_orders/new
  # GET /work_orders/new.xml
  def new
    @work_order = WorkOrder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @work_order }
    end
  end

  # GET /work_orders/1/edit
  def edit
  end

  # POST /work_orders
  # POST /work_orders.xml
  def create
    @work_order = @car.work_orders.build(params[:work_order])
    @work_order.save!
    respond_to do |format|
      flash[:notice] = 'Work Order was successfully created.'
      format.html { redirect_to(edit_car_work_order_path(@car, @work_order)) }
      format.xml  { render :xml => @work_order, :status => :created, :location => @work_order }
    end
    
  rescue ActiveRecord::RecordInvalid => e
    @work_order.valid?
    respond_to do |format|      
      format.html { render :action => "new" }
      format.xml  { render :xml => @work_order.errors }
    end
  end

  # PUT /work_orders/1
  # PUT /work_orders/1.xml
  def update

    @work_order.update_attributes!(params[:work_order])
    respond_to do |format|
      flash[:notice] = 'Work Order was successfully updated.'
      format.html { redirect_to car_work_order_path(@car, @work_order) }
      format.js   do
        render :update do |page|
          page[:spinner].hide
          page[:work_order_notice].show
          page[:work_order_notice].replace_html "Work order updated."
          page.delay(5) do
            page.visual_effect :fade, 'work_order_notice'
          end
        end
      end
      format.xml  { head :ok }
    end
    
  rescue ActiveRecord::RecordInvalid => e
    @work_order.valid?
    respond_to do |format|      
      format.html { render :action => "edit" }
      format.xml  { render :xml => @work_order.errors }
    end
  end

  # DELETE /work_orders/1
  # DELETE /work_orders/1.xml
  def destroy
    @work_order.destroy

    respond_to do |format|
      format.html { redirect_to(car_work_orders_url) }
      format.xml  { head :ok }
    end
  end
      
private 

  def expose_models
    @car = current_user.cars.find(params[:car_id])
    @work_order = @car.work_orders.find(params[:id]) unless params[:id].blank?
  end
  
end
