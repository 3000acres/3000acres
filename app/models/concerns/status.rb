module Status
  extend ActiveSupport::Concern

  STATUSES = [ "potential", "proposed", "active", "independent" ]

  included do
    validates :status, :presence => true # for the benefit of simple_form
    validates :status, 
              :inclusion => { :in => STATUSES,
                              :message => "%{value} is not a valid status" 
                            },
              :allow_nil => false,
              :allow_blank => false
  end
end
