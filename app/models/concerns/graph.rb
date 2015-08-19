module Graph
  # Error handling is mostly for dev not having an id, 
  # koala has its own error handling for facebook calls.

  def self.graph_authorize
    begin
      @oauth = Koala::Facebook::OAuth.new
      @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
    rescue
      # TODO warning that graph id doesn't authorize
    end
  end

  def self.get_graph_events(id)
    begin 
      graph_authorize
      fields = 'id, name, cover, description, end_time' 
      @graph.get_connection(id, "events", { fields: fields })
    rescue
      # TODO warning that graph id doesn't authorize
      []
    end
  end

  def self.get_graph_page(url)
    begin 
      graph_authorize
      options = {:params => { id: url }}
      @graph.graph_call('', {}, 'get', options) 
    rescue
      # TODO warning that graph id doesn't authorize
      Hash.new
    end
  end

end
