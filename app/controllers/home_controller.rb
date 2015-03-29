class HomeController < ApplicationController

  layout "home"

  def index
    @users = User.all
    @sites = Site.all
  end
end
