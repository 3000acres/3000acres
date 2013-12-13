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
  scenario "footer includes newsletter signup" do
    visit root_path
    find('#newsletter-footer').should have_content "Subscribe to our newsletter"
    find('#newsletter-footer').should have_field "EMAIL"
  end
end
