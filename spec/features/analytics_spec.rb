require 'spec_helper'

feature "analytics" do
  scenario "appears on each page" do
    Acres::Application.config.analytics_code = "ceci n'est pas l'analytics"
    # visit a random handful of pages
    [root_path, sites_path, users_path].each do |p|
      visit p
      page.should have_content "ceci n'est pas l'analytics"
    end
  end
end
