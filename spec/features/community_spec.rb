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
      @site = Site.last
    end

    scenario "post an update about a site" do
      visit site_path(@site)
      page.should have_content "Post an update"
      page.should have_content "Your message"
      fill_in "Subject", :with => "Test post"
      fill_in "Your message", :with => "Here is some news about the garden"
      click_button "Create Post"
      current_path.should eq site_path(@site)
      page.should have_content "Test post"
      page.should have_content "Posted by #{@user.name}"
      page.should have_content "less than a minute ago"
      page.should have_content "Here is some news about the garden"
    end

  end
end
