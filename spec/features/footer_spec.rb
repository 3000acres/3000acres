require 'spec_helper'

feature "footer" do
  include UIHelper

  scenario "footer shows on front page" do
    visit root_path
    expect(page).to have_css "footer"
  end
  scenario "footer shows on other pages" do
    visit new_user_session_path # signin page
    expect(page).to have_css "footer"
  end
end
