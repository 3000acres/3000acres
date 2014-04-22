class Mailer < ActionMailer::Base
  default from: ENV["SEND_EMAIL_FROM"]

  def site_added_notification(user, site)
    @user = user
    @site = site
    mail(
      :to => @user.email,
      :subject => "Thanks for adding #{site.to_s} to #{Acres::Application.config.site_name}"
    )
  end
end
