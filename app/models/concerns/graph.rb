module Graph

  def self.graph_authorize
    # @oauth = Koala::Facebook::OAuth.new
    # @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
  end

  def self.get_graph_events(id)
    # graph_authorize
    # fields = 'id, name, cover, description, end_time' 
    # @graph.get_connection(id, "events", { fields: fields })
  end

  def self.get_graph_page(url)
    # graph_authorize
    # options = {:params => { id: url }}
    # @graph.graph_call('', {}, 'get', options) 
  end

end
