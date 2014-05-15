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
end
