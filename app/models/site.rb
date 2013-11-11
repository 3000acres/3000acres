class Site < ActiveRecord::Base

validates :address, :presence => true
validates :suburb, :presence => true

STATUSES = [ "unknown", "suitable", "unsuitable", "in-progress", "active" ]
validates :status, :presence => true # for the benefit of simple_form
validates :status, :inclusion => { :in => STATUSES,
        :message => "%{value} is not a valid status" },
        :allow_nil => false,
        :allow_blank => false

LGAS = [
]

end
