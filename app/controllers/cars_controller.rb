class CarsController < ApplicationController
  before_filter :login_required, :expose_models
  layout 'registration'
  
  # GET /cars
  # GET /cars.xml
  def index
    redirect_to new_car_path and return if current_user.cars.empty?
    @cars = current_user.cars

    respond_to do |format|
      format.html { render :layout => 'garage' } 
      # format.xml  { render :xml => @cars }
    end
  end

  # GET /cars/1
  # GET /cars/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      # format.xml  { render :xml => @car }
    end
  end

  # GET /cars/new
  # GET /cars/new.xml
  def new
    @car = current_user.cars.build

    respond_to do |format|
      format.html # new.html.erb
      # format.xml  { render :xml => @car }
    end
  end

  # GET /cars/1/edit
  def edit
  end

  # POST /cars
  # POST /cars.xml
  def create
    @car = current_user.cars.build(params[:car])
    @car.save!

    respond_to do |format|
      flash[:notice] = 'Car was successfully created.'
      format.html { redirect_to(@car) }
      # format.xml  { render :xml => @car, :status => :created, :location => @car }
    end
    
  rescue ActiveRecord::RecordInvalid => e
    @car.valid?
    respond_to do |format|
      format.html { render :action => "new" }
      # format.xml  { render :xml => @car.errors }
    end
  end

  # PUT /cars/1
  # PUT /cars/1.xml
  def update
    @car.update_attributes!(params[:car])
    
    respond_to do |format|
      flash[:notice] = "#{@car.name} was successfully updated."
      format.html { redirect_to(@car) }
      # format.xml  { head :ok }
    end

  rescue ActiveRecord::RecordInvalid => e
    @car.valid?
    respond_to do |format|
      format.html { render :action => "edit" }
      # format.xml  { render :xml => @car.errors }
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.xml
  def destroy
    @car.destroy

    respond_to do |format|
      format.html { redirect_to(cars_url) }
      # format.xml  { head :ok }
    end
  end
  
private

  def expose_models
    @car = current_user.cars.find(params[:id]) unless params[:id].blank?
  end

end
