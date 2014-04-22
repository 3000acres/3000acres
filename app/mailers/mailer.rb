class Mailer < ActionMailer::Base
  default from: Figaro.env.send_email_from

  def site_added_notification(user, site)
    @user = user
    @site = site
    mail(
      :to => @user.email,
      :subject => "Thanks for adding #{site.to_s} to #{Figaro.env.acres_site_name}"
    )
  end
end
