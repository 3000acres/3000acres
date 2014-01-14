require 'spec_helper'

feature "map" do
  scenario "map shows on front page" do
    visit root_path
    page.should have_selector 'div#map'
  end
end
