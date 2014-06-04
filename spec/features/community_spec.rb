require 'spec_helper'

feature "post" do
  context "signed in user" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      visit root_path
      click_link 'navbar-signin'
      fill_in 'Login', :with => @user.email
      fill_in 'Password', :with => @user.password
      click_button 'Sign in'
      visit root_path
      click_link "Add a site"
      fill_in 'Address', :with => '1 Smith St'
      fill_in 'Suburb', :with => 'Smithville'
      click_button 'Create Site'
    end

    scenario "post an update about a site" do
      visit site_path(Site.last)
      page.should have_content "Post an update"
      page.should have_content "Your message"
    end

  end
end
