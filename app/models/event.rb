# No Active Record here, this is modeling facebook data.
class Event

  class EventObject < Dish::Plate
    coerce :start_time, ->(value) { DateTime.parse(value) }
    coerce :end_time, ->(value) { DateTime.parse(value) }

    def times
      result = self.start_time.strftime("%A, %B %d at %I:%M%p")
      result += self.end_time.strftime(" - %I:%M%p") unless self.end_time.blank? 
    end
  end

  def self.all
    authorize
    events = []
    # Get acres facebook events.
    events.concat(build_events(ENV['acres_fb_id'], ENV['acres_site_name'], ENV['acres_host']))
    # Gt events for sites with facebook pages.
    Site.where.not(facebook_id: nil).each do |site|
      events.concat(build_events(site.facebook_id, site.to_s, Rails.application.routes.url_helpers.site_url(site, only_path: true)))
    end
    events.sort_by!(&:start_time)
  end

  private 

  def self.authorize
    @oauth = Koala::Facebook::OAuth.new
    @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
  end

  def self.build_events(id, name, url)
    event_objects = []
    events = get_facebook_events(id)
    events.each do |event|
      event['site'] = { 'name' => name, 'url' => url }
      # Convert hash to an Event object and add to @events array.
      event_objects << Dish(event, EventObject)
    end
    event_objects
  end

  def self.get_facebook_events(id)
    @graph.get_connection(id, "events", { fields: 'id, name, cover, place, description, end_time' })
  end
end
