require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Acres
  class Application < Rails::Application

    # don't generate RSpec tests for views and helpers
    config.generators do |g|

      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'

      g.view_specs false
      g.helper_specs false
    end

    #
    # 3000 Acres specific config.  Edit stuff below here if you've forked the app!
    #

    # config.region
    # this region is appended to "address, suburb" when doing geocoding
    config.region = 'Victoria, Australia'

    # config.forbidden_usernames
    # usernames which are forbidden when people are signing up
    config.forbidden_usernames = %w(acres 3000acres 3000_acres admin moderator staff)

    Gibbon::API.api_key = Figaro.env.mailchimp_apikey
    Gibbon::API.timeout = 10
    Gibbon::API.throws_exceptions = false
    config.newsletter_list_id = Figaro.env.mailchimp_newsletter_id

  end
end
