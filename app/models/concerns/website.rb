module Website
  extend ActiveSupport::Concern

  included do 
    validates :website, :url => { :allow_blank => true, :allow_nil => true }
    before_validation :normalise_website
  end

  def normalise_website
    if (!self.website.blank?) && (!/https?:\/\//.match(self.website))
      self.website = "http://#{self.website}"
    end
  end

end
