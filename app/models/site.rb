class Site < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, :use => [:slugged, :finders]

  belongs_to :local_government_area

  validates :address, :presence => true
  validates :suburb, :presence => true

  STATUSES = [ "unknown", "suitable", "unsuitable", "in-progress", "active" ]
  validates :status, :presence => true # for the benefit of simple_form
  validates :status, :inclusion => { :in => STATUSES,
          :message => "%{value} is not a valid status" },
          :allow_nil => false,
          :allow_blank => false

  geocoded_by :full_address
  after_validation :geocode

  # slug_candidates()
  # used to generate a slug for friendly_id
  # this will generate eg. 1-smith-st-jonestown
  def slug_candidates
    [
      "#{address} #{suburb}"
    ]
  end

  # full_address()
  # used for geocoding
  # will generate eg. 1 smith st, jonestown, victoria, australia
  # edit config/application.rb to change the region used
  def full_address
    [address, suburb, Acres::Application.config.region].compact.join(', ')
  end

  def to_s
    return name.blank? ? "#{address}, #{suburb}" : name
  end

end
