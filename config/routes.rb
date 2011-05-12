ActionController::Routing::Routes.draw do |map|

  map.resources :cars do |cars|
    cars.resources :work_orders, :collection => { :auto_complete_for_work_order_shop => :post }
  end
  
  map.resources :work_orders, :has_many => :line_items

  map.open_id_complete 'session', :controller => "sessions", :action => "create", :conditions => { :method => :get }
  
  map.resource :user, :session
  map.resources :showrooms

  map.with_options :controller => 'about' do |about|
    about.home  '',           :action => 'home'
    about.about '/about',     :action => 'index'
    about.privacy '/privacy', :action => 'privacy'
    about.tos '/tos',         :action => 'tos'
  end

end
