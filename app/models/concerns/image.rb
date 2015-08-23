module Image
  extend ActiveSupport::Concern

  included do 
    has_attached_file :image, 
                      :styles => { :large => "720x720", :medium => "360x360#", :small => "180x180#" }, 
                      :default_url => "/images/:style/missing.png"
    validates_attachment :image, 
        :content_type => { :content_type => /\Aimage\/.*\Z/ },
        :size => { :less_than => 4.megabytes }
  end
end
