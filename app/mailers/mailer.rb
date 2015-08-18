class Mailer < ActionMailer::Base
  default from: ENV['send_email_from'] || 'noreply@example.com'

  # These class methods make testing easier as mailer behaviour is WEIRD.
  # It also keeps mailer behaviours like deliver! all in one place.

  def self.send_site_created_thanks!(site, recipient)
    site_created_thanks(site, recipient).deliver!
  end

  def self.send_site_created_notification!(site, recipient)
    site_created_notification(site, recipient).deliver!
  end
  
  def self.send_site_changed_notification!(site, recipient)
    site_changed_notification(site, recipient).deliver!
  end
  
  def self.send_new_watcher_notification!(new_watcher, site, recipient)
    new_watcher_notification(new_watcher, site, recipient).deliver!
  end
  
  def self.send_post_created_notification!(post, recipient)
    post_created_notification(post, recipient).deliver!
  end
  
  def site_created_thanks(site, recipient)
    @user = recipient
    @site = site
    mail(
      :to => @user.email,
      :subject => "Thanks for adding #{@site.to_s} to #{ENV['acres_site_name']}"
    )
  end

  def site_created_notification(site, recipient)
    @recipient = recipient
    @site = site
    mail(
      :to => @recipient.email,
      :subject => "#{@site.to_s} was added"
    )
  end

  def site_changed_notification(site, recipient)
    @site = site
    @recipient = recipient
    mail(
      :to => @recipient.email,
      :subject => "#{@site.to_s}'s details were changed"
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

  def post_created_notification(post, recipient)
    @post = post
    @recipient = recipient
    mail(
      :to => @recipient.email,
      :subject => "#{@post.user.name} posted #{@post.subject} on #{@post.site.to_s}"
    )
  end

end
