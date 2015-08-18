module Notify
  extend ActiveSupport::Concern

  included do 
    after_create :send_added_email, :notify_new
    after_update :notify_update
  end

  # send_added_email()
  # when a user adds a site, send them a thank you email
  def send_added_email
    if added_by_user.send_email # don't spam!
      Mailer.site_added_thanks(self.added_by_user, self).deliver!
    end
  end

  def notify_new
    User.with_role :admin do |user|
      Mailer.site_added_notification(user, self)
    end
  end

  def notify_update
    User.with_role :admin do |user|
      Mailer.site_changed_notification(user, self)
    end
  end

end
