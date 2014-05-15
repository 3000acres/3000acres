class Site < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, :use => [:slugged, :finders]

  belongs_to :local_government_area
  belongs_to :added_by_user, :class_name => 'User'
  has_many :watches

  validates :address, :presence => true
  validates :suburb, :presence => true

  STATUSES = [ "unknown", "unsuitable", "potential", "proposed", "active" ]
  validates :status, :presence => true # for the benefit of simple_form
  validates :status, :inclusion => { :in => STATUSES,
          :message => "%{value} is not a valid status" },
          :allow_nil => false,
          :allow_blank => false
  validates :website, :url => { :allow_blank => true, :allow_nil => true }

  before_validation :normalise_website
  geocoded_by :full_address
  after_validation :geocode
  after_create :autowatch
  after_create :send_added_email

  # autowatch()
  # When a user adds a site, they automatically get to watch it. Unless
  # they're an admin, in which case that would be overwhelming.
  def autowatch
    unless added_by_user.has_role?(:admin)
      Watch.create(
        :site_id => id,
        :user_id => added_by_user_id
      )
    end
  end

  # send_added_email()
  # when a user adds a site, send them a thank you email
  def send_added_email
    if added_by_user.send_email # don't spam!
      Mailer.site_added_notification(self.added_by_user, self).deliver!
    end
  end

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

  def normalise_website
    if (!self.website.blank?) && (!/https?:\/\//.match(self.website))
      self.website = "http://#{self.website}"
    end
  end

end
