class HomeController < ApplicationController

  layout "home"

  def index
    @users = User.all
    @featured_sites = Site.where(:featured => true)
  end
end
