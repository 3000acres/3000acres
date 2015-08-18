module Watches
  extend ActiveSupport::Concern

  included do
    has_many :watches
    has_many :users, through: :watches
    after_create :autowatch
    after_update :send_changed_email
  end

  # When a user adds a site, they automatically get to watch it.
  def autowatch
    Watch.create(
      :site_id => id,
      :user_id => added_by_user_id
    )
  end

  # When a site's details are changed, send an email to watchers.
  def send_changed_email
    if changed?
      watches.each do |watch|
        recipient = watch.user
        if recipient.send_email # don't spam
          Mailer.send_site_changed_notification!(self, recipient)
        end
      end
    end
  end

end
