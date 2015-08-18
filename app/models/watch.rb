class Watch < ActiveRecord::Base

  belongs_to :user
  belongs_to :site

  after_create :send_new_watcher_email

  # When a user watches a site, send other watchers an email.
  def send_new_watcher_email
    new_watcher = self.user
    site = self.site

    # I'm sure there's a better way to do this using Array.reject or
    # something but I can't figure it out right now.
    self.site.watches.each do |watch|
      unless watch.user == self.user # don't send notifications of your own watch to yourself!
        recipient = watch.user
        if recipient.send_email # don't spam
          Mailer.new_watcher_notification(new_watcher, site, recipient).deliver!
        end
      end
    end
  end

end
