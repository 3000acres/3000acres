class Site < ActiveRecord::Base

validates :address, :presence => true
validates :suburb, :presence => true

STATUSES = [ "unknown", "suitable", "unsuitable", "in-progress", "active" ]

LGAS = [
]

end
