module Notify
  extend ActiveSupport::Concern

  included do 
    after_create :send_created_email, :send_created_admin_email
    after_update :send_changed_admin_email
  end

  # When a user adds a site, send them a thank you email.
  def send_created_email
    if added_by_user.send_email # don't spam!
      Mailer.send_site_created_thanks!(self, self.added_by_user)
    end
  end

  # Always notify admin of new sites.
  def send_created_admin_email
    User.with_role(:admin).each do |recipient|
      if recipient.send_email # don't spam
        Mailer.send_site_created_notification!(self, recipient)
      end
    end
  end

  # Always notify admin of site updates.
  def send_changed_admin_email
    if changed?
      User.with_role(:admin).each do |recipient|
        if recipient.send_email # don't spam
          Mailer.send_site_changed_notification!(self, recipient)
        end
      end
    end
  end

end
