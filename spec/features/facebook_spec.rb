require 'spec_helper'

feature "facebook feed" do
  scenario "facebook feed shows on front page" do
    visit root_path
    page.should have_selector 'div.fb-like-box'
  end
end
