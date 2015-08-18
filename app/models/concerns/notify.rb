module Notify
  extend ActiveSupport::Concern

  included do 
    after_create :notify_created_email, :notify_created_admin_email
    after_update :notify_changed_admin_email
  end

  # When a user adds a site, send them a thank you email.
  def notify_created_email
    if added_by_user.send_email # don't spam!
      Mailer.send_site_created_thanks!(self, self.added_by_user)
    end
  end

  # Always notify admin of new sites.
  def notify_created_admin_email
    User.with_role(:admin).each do |user|
      Mailer.send_site_created_notification!(self, user)
    end
  end

  # Always notify admin of site updates.
  def notify_changed_admin_email
    if changed?
      User.with_role(:admin).each do |user|
        Mailer.send_site_changed_notification!(self, user)
      end
    end
  end

end
