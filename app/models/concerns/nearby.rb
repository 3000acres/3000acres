module Nearby
  extend ActiveSupport::Concern

  def nearby_sites
    # Return nearby sites excluding self.
    Site.where.not(slug: self.slug).near([self.latitude, self.longitude], 4, units: :km)
  end

  def nearby_users
    users = [] 
    self.nearby_sites.each do |site|
      users = users | site.users
    end
    users
  end

end
