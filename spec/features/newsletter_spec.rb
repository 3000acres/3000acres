require 'spec_helper'

feature "newsletter" do
  include UIHelper

  scenario "sign up form includes newsletter checkbox" do
    visit root_path
    click_link 'navbar-signup'
    page.should have_content("Newsletter")
  end

  scenario "edit account includes newsletter checkbox" do
    log_in
    click_link 'Edit account'
    page.should have_content("Newsletter")
  end
end

