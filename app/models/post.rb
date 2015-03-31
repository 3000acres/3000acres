class Post < ActiveRecord::Base

  belongs_to :site
  belongs_to :user

  default_scope { order("created_at ASC") }

  after_create :send_post_email

  # send_post_email()
  # when a user posts an update about a site, send email to watchers
  def send_post_email
    # I'm sure there's a better way to do this using Array.reject or
    # something but I can't figure it out right now.
    self.site.watches.each do |watch|
      unless watch.user == self.user # don't send notifications of your own post to yourself!
        recipient = watch.user
        if recipient.send_email # don't spam
          Mailer.post_notification(self, recipient).deliver!
        end
      end
    end
  end
end
