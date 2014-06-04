class Mailer < ActionMailer::Base
  default from: ENV['send_email_from'] || 'noreply@example.com'

  def site_added_notification(user, site)
    @user = user
    @site = site
    mail(
      :to => @user.email,
      :subject => "Thanks for adding #{site.to_s} to #{ENV['acres_site_name']}"
    )
  end

  def new_watcher_notification(new_watcher, site, recipient)
    @new_watcher = new_watcher
    @site = site
    @recipient = recipient
    mail(
      :to => @recipient.email,
      :subject => "Someone new is watching #{@site.to_s} on #{ENV['acres_site_name']}"
    )
  end
end
