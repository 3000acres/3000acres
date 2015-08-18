# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'email_spec'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.before(:each) do

    # Stub facebook methods and vars before all tests.
    Graph.stub(:get_graph_events).and_return []
    Graph.stub(:graph_authorize)
    Graph.stub(:get_graph_page) do |url|  
      # Return a mock facebook id based on any numbers in the url.
      id = url.scan(/\d/).first
      id.nil? ? { 'id' => url } : { 'id' => id, 'name' => 'foo' }
    end

    # Stub acres site vars for facebook events.
    Figaro.env.stub(:acres_fb_id).and_return(99)
    Figaro.env.stub(:acres_site_name).and_return("acres")
    Figaro.env.stub(:acres_host).and_return("localhost")

    # Use a constant current time for any event related tests, instead of "now".
    class Event
      def self.current_time
        "2015-01-01T01:01:00+1000".to_datetime
      end
    end

    # Just don't call geocoder during a test, ever.
    Site.any_instance.stub(:geocode)

  end
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
