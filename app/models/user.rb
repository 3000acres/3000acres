class User < ActiveRecord::Base
  rolify

  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :watches
  has_many :sites_added, :class_name => 'Site', :foreign_key => :added_by_user_id

  validates :name,
    :length => {
      :minimum => 2,
      :maximum => 25,
      :message => "should be between 2 and 25 characters long"
    },
    :exclusion => {
      :in => Acres::Application.config.forbidden_usernames,
      :message => "name is reserved"
    },
    :format => {
      :with => /\A\w+\z/,
      :message => "may only include letters, numbers, or underscores"
    },
    :uniqueness => {
      :case_sensitive => false
    }

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'name'
  attr_accessor :login

  after_save :update_newsletter_subscription


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


  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

end
