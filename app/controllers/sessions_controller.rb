# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout 'profile'

  def new
  end

  def create
    if using_open_id?
      open_id_authentication(params[:openid_url])
    else
      password_authentication(params[:name], params[:password])
    end
  rescue OpenIdAuthentication::InvalidOpenId
    failed_login "You must provide a valid OpenID."
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
  
protected
  def password_authentication(name, password)
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      successful_login
    else
      failed_login "Sorry, that username/password doesn't work"
    end
  end

  def open_id_authentication(identity_url)
    # Pass optional :required and :optional keys to specify what sreg fields you want.
    # Be sure to yield registration, a third argument in the #authenticate_with_open_id block.
    authenticate_with_open_id(identity_url, 
        :required => [ :nickname, :email ]) do |status, identity_url, registration|
      case status.code
      when :missing
        failed_login "Sorry, the OpenID server couldn't be found"
      when :canceled
        failed_login "OpenID verification was canceled"
      when :failed
        failed_login "Sorry, the OpenID verification failed"
      when :successful
        @current_user = User.find_or_initialize_by_identity_url(identity_url)
        
        assign_registration_attributes!(registration)

        if @current_user.save
          self.current_user = @current_user
          successful_login
        else
          failed_login "Your OpenID profile registration failed: " +
          @current_user.errors.full_messages.to_sentence
        end
      else
        raise status.inspect
      end
    end
  end
  
  # registration is a hash containing the valid sreg keys given above
  # use this to map them to fields of your user model
  def assign_registration_attributes!(registration)
    model_to_registration_mapping.each do |model_attribute, registration_attribute|
      unless registration[registration_attribute].blank?
        @current_user.send("#{model_attribute}=", registration[registration_attribute])
      end
    end
  end

  def model_to_registration_mapping
    { :display_name => 'nickname', :email => 'email' }
  end



private

  def successful_login
    if params[:remember_me] == "1"
      self.current_user.remember_me
      cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
    end
    if self.current_user.display_name.nil? || self.current_user.email.nil?
      flash[:error] = "Please complete your profile before continuing."
      redirect_to edit_user_url
    else
      redirect_to cars_url
    end
  end

  def failed_login(message)
    flash[:error] = message
    render :action => 'new'
  end

end
