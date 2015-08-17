module Watches
  extend ActiveSupport::Concern

  included do
    has_many :watches
    has_many :users, through: :watches
    after_create :autowatch
  end

  # When a user adds a site, they automatically get to watch it.
  def autowatch
    Watch.create(
      :site_id => id,
      :user_id => added_by_user_id
    )
  end
end
