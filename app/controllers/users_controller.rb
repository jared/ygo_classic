class UsersController < ApplicationController

  layout 'profile'
  before_filter :login_required, :only => [ :edit, :update, :show ]

  def show
    redirect_to edit_user_path and return
  end

  def new
    @user = User.new
  end
  
  def edit
    @user = current_user
  end

  def create
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    UserMailer.deliver_register(@user, request.host_with_port)
    redirect_back_or_default(new_car_path)
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
  
  def update
    @user = current_user
    @user.update_attributes!(params[:user])
    redirect_back_or_default(cars_url)
    
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end
  
end
