require 'spec_helper'
require 'rake'

feature "cms" do
  include UIHelper

  before(:each) do
    @user = FactoryGirl.create(:user)
    @admin_user = FactoryGirl.create(:admin_user)

  end

  scenario "users can't view CMS admin if not signed in" do
    visit comfy_admin_cms_path
    current_path.should == root_path
    page.should have_content("Please sign in as an admin user")
  end

  scenario "users can't view CMS admin or edit links if not an admin user" do
    log_in
    expect(page).not_to have_css ".snippet-edit"
    visit comfy_admin_cms_path
    current_path.should == root_path
    expect(page).to have_content("Please sign in as an admin user")
  end

  scenario "admin users can view CMS admin area and edit links" do
    log_in_as_admin
    visit root_path
    expect(page).to have_css ".snippet-edit"
    visit comfy_admin_cms_path
    current_path.should match /#{comfy_admin_cms_path}/ # match any CMS admin page
  end

  # This works IF snippets are loaded into the test database.
  # Mockups arent as straighforward as they should be and we cant use cms fixtures methods,
  # and its only for admin, so postponed.
  pending "admin users can edit and update snippets" do
    log_in_as_admin
    visit root_path
    first('.snippet-edit').click
    find('snippet_content').set('Holy Foo!')
    click_button 'Update Snippet'
    expect(page).to have_content 'Holy Foo!'
  end
end
