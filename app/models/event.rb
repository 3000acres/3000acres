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
    # Get acres facebook events.
    id = Figaro.env.acres_fb_id
    name = Figaro.env.acres_site_name
    url = Figaro.env.acres_host
    events = build_events(Graph.get_graph_events(id), name, url)

    # Get events for sites with facebook pages.
    Site.where.not(facebook_id: nil).each do |site|
      id = site.facebook_id
      name = site.to_s
      url = Rails.application.routes.url_helpers.site_url(site, only_path: true)
      events.concat(build_events(Graph.get_graph_events(id), name, url))
    end

    events.sort_by!(&:start_time)
  end

  def self.page_events(id, name = "", url = "")
    events = build_events(Graph.get_graph_events(id), name, url)
    events.sort_by!(&:start_time)
  end


  private 

  def self.build_events(graph_events, name, url)
    begin
      events = []
      unless graph_events.nil?
        graph_events.each do |graph_event|
          next if graph_event['id'].blank?
          graph_event = add_site_data(graph_event, name, url)
          # Convert graph event hash to an object.
          event = hash_to_object(graph_event)

          # Add event only if the start time is in the future.
          events << event if event.start_time > current_time
        end
      end
      events
    rescue
      # Catch facebook errors, and return an empty array. 
      # TODO alert bugsnag or something to monitor fb hit failures.
      []
    end
  end

  def self.current_time
    DateTime.now
  end

  def self.add_site_data(graph_event, name, url)
    graph_event['site'] = { 'name' => name, 'url' => url }
    graph_event
  end
  
  def self.hash_to_object(graph_event)
    Dish(graph_event, EventObject)
  end

end
