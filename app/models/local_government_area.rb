class LocalGovernmentArea < ActiveRecord::Base

has_many :sites
validates :name, :presence => true

end
