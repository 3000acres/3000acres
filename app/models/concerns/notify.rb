module Notify
  extend ActiveSupport::Concern

  included do 
    after_create :send_added_email
    after_update :send_changed_email
  end

  # send_added_email()
  # when a user adds a site, send them a thank you email
  def send_added_email
    if added_by_user.send_email # don't spam!
      Mailer.site_added_notification(self.added_by_user, self).deliver!
    end
  end

  # send_changed_email()
  # when a site's details are changed, send an email to watchers
  def send_changed_email
  include Notify
    if changed?
      watches.each do |watch|
        recipient = watch.user
        if recipient.send_email # don't spam
          Mailer.site_changed_notification(self, recipient).deliver!
        end
      end
    end
  end

end
