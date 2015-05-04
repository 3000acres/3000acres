require 'spec_helper'

feature "map" do
  scenario "map shows on sites page" do
    visit sites_path
    page.should have_selector 'div#map'
  end
end
