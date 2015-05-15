require 'pp'
# No Active Record here, this is modeling facebook data.
class Event

  class EventObject < Dish::Plate
    coerce :start_time, ->(value) { value.blank? ? '' : DateTime.parse(value) }
    coerce :end_time, ->(value) { value.blank? ? '' : DateTime.parse(value) }

    def times
      result = ''
      result = self.start_time.strftime("%A, %B %d at %I:%M%p") unless self.start_time.blank?
      result += self.end_time.strftime(" - %I:%M%p") unless self.end_time.blank? 
    end
  end

  def self.all
    authorize
    events = []
    # Get acres facebook events.
    events.concat(build_events(Figaro.env.acres_fb_id, Figaro.env.acres_site_name, Figaro.env.acres_host))
    # Gt events for sites with facebook pages.
    Site.where.not(facebook_id: nil).each do |site|
      events.concat(build_events(site.facebook_id, site.to_s, Rails.application.routes.url_helpers.site_url(site, only_path: true)))
    end
    events.sort_by!(&:start_time)
  end

  def self.get_facebook_events(id)
    @graph.get_connection(id, "events", { fields: 'id, name, cover, description, end_time' })
  end

  private 

  def self.authorize
    @oauth = Koala::Facebook::OAuth.new
    @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
  end

  def self.build_events(id, name, url)
    begin
      event_objects = []
      events = get_facebook_events(id)
      # pp events
      if !events.nil?
        events.each do |event|
          next if event['id'].blank?
          event = add_site_data(event, name, url)
          # Convert hash to an Event object and add to @events array.
          event_objects << hash_to_object(event)
        end
      end
      event_objects
    rescue
      # Catch facebook errors, and return an empty array. 
      # TODO alert bugsnag or something to monitor fb hit failures.
      []
    end
  end

  def self.add_site_data(event, name, url)
    event['site'] = { 'name' => name, 'url' => url }
    event
  end
  
  def self.hash_to_object(event)
    Dish(event, EventObject)
  end

end
