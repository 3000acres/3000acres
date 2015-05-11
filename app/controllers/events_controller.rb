class EventsController < ApplicationController

  caches_action :index, :expires_in => 1.hours
  def index
    @events = Event.all
  end

end
