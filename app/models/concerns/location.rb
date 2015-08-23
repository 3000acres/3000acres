module Location
  extend ActiveSupport::Concern

  included do 
    validates :address, :presence => true
    validates :suburb, :presence => true
    after_validation :geocode
    geocoded_by :full_address
  end

  # full_address()
  # used for geocoding
  # will generate eg. 1 smith st, jonestown, victoria, australia
  # edit config/application.rb to change the region used
  def full_address
    [address, suburb, Acres::Application.config.region].compact.join(', ')
  end
end
