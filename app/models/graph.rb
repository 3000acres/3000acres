class Graph
  # Error handling is mostly for dev not having an id, 
  # koala has its own error handling for facebook calls.

  def self.get_graph_events(id)
    begin 
      if graph = graph_authorize
        fields = 'id, name, cover, description, end_time' 
        graph.get_connection(id, "events", { fields: fields })
      else 
        Rails.logger.debug "Graph::get_graph_events - graph authorize returned nil" if Rails.logger.debug?
        []
      end
    rescue => error
      Rails.logger.debug "Graph::get_graph_events failed with error: #{error.message}" if Rails.logger.debug?
      []
    end
  end

  def self.get_graph_page(url)
    begin 
      if graph = graph_authorize
        options = {:params => { id: url }}
        graph.get_object(get_path_identifier(url)) 
      else 
        Rails.logger.debug "Graph::get_graph_page: graph authorize returned nil" if Rails.logger.debug?
        Hash.new
      end

    rescue => error
      Rails.logger.debug "Graph::get_graph_page error.message failed with error: - #{error.message}" if Rails.logger.debug?
      Hash.new
    end
  end

  def self.graph_authorize
    begin
      oauth = Koala::Facebook::OAuth.new
      Koala::Facebook::API.new(oauth.get_app_access_token, Facebook::SECRET.to_s)
    rescue => error
      Rails.logger.debug "Graph::graph_authorize failed with error:  #{error.message}" if Rails.logger.debug?
      return nil
    end
  end

  def self.get_path_identifier(url)
    uri = URI.parse(url)
    path_split = uri.path.split('/')
    return "" unless path_split and !path_split[1].blank?
    # If page has its own url use first eliment after the slash (usually the name), 
    # if it's is under /pages use the last element (usually the id)
    path_split[1] == "pages" ? path_split.last : path_split[1]
  end

end
