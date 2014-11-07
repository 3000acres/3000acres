require 'spec_helper'

feature "cms admin" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @admin_user = FactoryGirl.create(:admin_user)
  end

  scenario "can't view CMS admin if not signed in" do
    visit comfy_admin_cms_path
    current_path.should == root_path
    page.should have_content("Please sign in as an admin user")
  end

  scenario "can't view CMS admin if not an admin user" do
    # sign in as an ordinary user
    visit root_path
    click_link 'navbar-signin'
    fill_in 'Login', :with => @user.email
    fill_in 'Password', :with => @user.password
    click_button 'Sign in'
    visit comfy_admin_cms_path
    current_path.should == root_path
    page.should have_content("Please sign in as an admin user")
  end

  scenario "admin users can view CMS admin area" do
    visit root_path
    # now we sign in as an admin user
    click_link 'navbar-signin'
    fill_in 'Login', :with => @admin_user.email
    fill_in 'Password', :with => @admin_user.password
    click_button 'Sign in'
    visit comfy_admin_cms_path
    current_path.should match /#{comfy_admin_cms_path}/ # match any CMS admin page
  end
end
