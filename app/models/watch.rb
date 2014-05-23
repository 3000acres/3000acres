class Watch < ActiveRecord::Base

  belongs_to :user
  belongs_to :site

  after_create :send_new_watcher_email

  # send_new_watcher_email()
  # when a user watches a site, send other watchers an email
  def send_new_watcher_email
    # I'm sure there's a better way to do this using Array.reject or
    # something but I can't figure it out right now.
    self.site.watches.each do |recipient|
      unless recipient = self # don't send notifications of your own watch to yourself!
        if recipient.send_email # don't spam
          Mailer.new_watcher_notification(self, recipient).deliver!
        end
      end
    end
  end
end
