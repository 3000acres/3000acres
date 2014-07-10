source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'cancan'
gem 'devise'
gem 'figaro'
gem 'haml-rails'
gem 'less-rails'
gem 'rolify'
gem 'simple_form', '>= 3.0.0.rc'
gem 'therubyracer', :platform=>:ruby
gem 'twitter-bootstrap-rails', :git => 'https://github.com/seyhunak/twitter-bootstrap-rails.git', :branch => 'bootstrap3'
gem 'unicorn'
gem 'mandrill-api'
gem 'gibbon' # for mailchimp newsletter subscriptions
gem 'geocoder'
gem 'leaflet-rails'
gem 'leaflet-markercluster-rails'
gem 'friendly_id'
gem 'validate_url'
gem 'bluecloth' # markdown formatting

# the following gem is needed to work around a really annoying change in
# Rails 4. See https://github.com/rails/sprockets-rails/issues/49 for
# more info.
gem 'non-stupid-digest-assets'

gem 'comfortable_mexican_sofa', '~> 1.9.0'

group :travis, :staging, :production do
  gem 'pg'
end

group :staging, :production do
  gem 'rails_12factor' # supresses heroku messages
  gem 'newrelic_rpm'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'letter_opener'
end

group :development, :test do
  gem 'sqlite3'
end

group :development, :test, :travis do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :test, :travis do
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'launchy'
end
