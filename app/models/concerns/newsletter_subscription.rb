module NewsletterSubscription
  extend ActiveSupport::Concern

  included do 
    after_save :update_newsletter_subscription
  end

  def update_newsletter_subscription
    if confirmed_at_changed? and newsletter # just signed up/confirmed email
      newsletter_subscribe
    elsif confirmed_at # i.e. after user's established their account
      if newsletter_changed? # edited user settings
        if newsletter
          newsletter_subscribe
        else
          newsletter_unsubscribe
        end
      end
    end
  end

  def newsletter_subscribe
    gb = Gibbon::API.new
    res = gb.lists.subscribe({
      :id => ENV['mailchimp_newsletter_id'],
      :email => { :email => email },
      :merge_vars => { :name => name },
      :double_optin => false # they alredy confirmed their email with us
    })
  end

  def newsletter_unsubscribe
    gb = Gibbon::API.new
    res = gb.lists.unsubscribe({
      :id => ENV['mailchimp_newsletter_id'],
      :email => { :email => email }
    })
  end
end
