module ProfileHelper
  
  module Commands
    
    def logs_in_as(user, password='test')
      post session_url, :login => user.login, :password => password
      assert_not_nil session[:user]
    end
    
    def logs_out
      delete session_url
      assert_nil session[:user]
    end
    
    def is_viewing(page)
      assert_response :success
      assert_template page
    end
    
    def is_redirected_to(url)
      assert_redirected_to url
    end
    
    def creates_a_new_account(params={})
      post_via_redirect user_path, :user => params
      is_viewing('new')
      assert_equal path, new_car_path, "New user should redirect to new car page."
    end
    
  end
  
  def new_session
    open_session do |sess|
      sess.extend(Commands)
      yield sess if block_given?
    end
  end
  
end