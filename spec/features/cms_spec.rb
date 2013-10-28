require 'spec_helper'

feature "cms admin" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @admin_user = FactoryGirl.create(:admin_user)
  end

  scenario "can't view CMS admin if not signed in" do
    visit cms_admin_path
    current_path.should == root_path
    page.should have_content("Please sign in as an admin user")
  end

  scenario "can't view CMS admin if not an admin user" do
    # sign in as an ordinary user
    visit root_path
    click_link 'Sign in'
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => @user.password
    click_button 'Sign in'
    visit cms_admin_path
    current_path.should == root_path
    page.should have_content("Please sign in as an admin user")
  end

  scenario "admin users can view CMS admin area" do
    visit root_path
    # now we sign in as an admin user
    click_link 'Sign in'
    fill_in 'Email', :with => @admin_user.email
    fill_in 'Password', :with => @admin_user.password
    click_button 'Sign in'
    visit cms_admin_path
    current_path.should match /#{cms_admin_path}/ # match any CMS admin page
  end
end
