class LocalGovernmentArea < ActiveRecord::Base

  has_many :sites
  validates :name, :presence => true

  def to_s
    return name
  end

end
