class Site < ActiveRecord::Base

  include Fb
  include Image
  include Location
  include Nearby
  include Notify
  include Status
  include Watches
  include Website

  extend FriendlyId
  friendly_id :slug_candidates, :use => [:slugged, :finders]

  belongs_to :local_government_area
  belongs_to :added_by_user, :class_name => 'User'
  has_many :posts

  # used to generate a slug for friendly_id eg. 1-smith-st-jonestown
  def slug_candidates
    [ "#{address} #{suburb}" ]
  end

  def to_s
    return name.blank? ? "#{address}, #{suburb}" : name
  end

end
