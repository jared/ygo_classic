class AboutController < ApplicationController

  layout 'about'
  after_filter(:except => :home) { |controller| controller.cache_page }
  
  def home
    render :layout => "home"
  end

  def index
  end

  def privacy
  end

  def tos
  end
  
  
end
