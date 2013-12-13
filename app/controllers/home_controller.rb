class HomeController < ApplicationController

  layout "home"

  def index
    @users = User.all
  end
end
