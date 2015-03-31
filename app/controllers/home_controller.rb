class HomeController < ApplicationController

  layout "home"

  def index
    @users = User.all
    @featured_sites = Site.where("image_file_name > ''")
  end
end
