module Fb
  extend ActiveSupport::Concern
  
  included do 
    validates :facebook, :url => { :allow_blank => true, :allow_nil => true }
    before_validation :normalise_facebook
    before_validation :set_facebook_id
  end

  def normalise_facebook
    if (!self.facebook.blank?)
      self.facebook[0] = '' if self.facebook[0] == '/'
      self.facebook = "facebook.com/#{self.facebook}" if (!/facebook\.com/.match(self.facebook))
      self.facebook = "http://#{self.facebook}" if (!/https?:\/\//.match(self.facebook))
    end
  end

  def set_facebook_id
    if !self.facebook.blank?
      page = get_facebook_page(self.facebook)
      if page['name'].blank?
        self.errors.add(:facebook, "Facebook page is invalid, try pasting in the full URL" )
      else
        self.facebook_id = page['id']
      end
    end
  end

  def get_facebook_page(url)
    @oauth = Koala::Facebook::OAuth.new
    @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
    options = {:params => { id: url }}
    @graph.graph_call('',{},'get',options) 
  end

  def facebook_events
    Event.select(self.facebook_id)
  end

end
