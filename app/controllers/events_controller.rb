class EventsController < ApplicationController

  def index
    @oauth = Koala::Facebook::OAuth.new
    @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
    @events = []
    # Get acres facebook events.
    @events.concat(build_events(ENV['acres_fb_id'], ENV['acres_site_name'], root_url))
    # Gt events for sites with facebook pages.
    Site.where.not(facebook: '').each do |site|
      page = get_facebook_page(site.facebook)
      @events.concat(build_events(page['id'], site.to_s, site_url(site)))
    end
    @events.sort_by!(&:start_time)
  end

  class Event < Dish::Plate
    coerce :start_time, ->(value) { DateTime.parse(value) }
    coerce :end_time, ->(value) { DateTime.parse(value) }

    def times
      result = self.start_time.strftime("%A, %B %d at %I:%M%p")
      result += self.end_time.strftime(" - %I:%M%p") unless self.end_time.blank? 
    end
  end

  def build_events(id, name, url)
    objects = []
    events = get_facebook_events(id)
    events.each do |event|
      event['site'] = { 'name' => name, 'url' => url }
      # Convert hash to an Event object and add to @events array.
      objects << Dish(event, Event)
    end
    objects
  end

  def get_facebook_events(id)
    @graph.get_connection(id, "events", { fields: 'id, name, cover, picture, place, description, end_time' })
  end

  def get_facebook_page(url)
    options = {:params => { id: url }}
    @graph.graph_call('',{},'get',options)
  end
end
