require 'spec_helper'

feature "footer" do
  scenario "footer shows on front page" do
    visit root_path
    page.should have_content "Twitter"
  end
  scenario "footer shows on other pages" do
    visit new_user_session_path # signin page
    page.should have_content "Twitter"
  end
end
