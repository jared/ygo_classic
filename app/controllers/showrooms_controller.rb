class ShowroomsController < ApplicationController
  
  layout 'garage'
  
  def show
    @featured_car = Car.find(params[:id])
    raise ActiveRecord::RecordNotFound if @featured_car.private?

  rescue ActiveRecord::RecordNotFound
    flash[:notice] = "Car #{params[:id]} not found or set as private."
    redirect_to home_url and return
  end
  
end
