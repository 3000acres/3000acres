require 'spec_helper'

feature "watches" do

  context "signed in user" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @site = FactoryGirl.create(:site)
      visit root_path
      click_link 'Sign in'
      fill_in 'Login', :with => @user.email
      fill_in 'Password', :with => @user.password
      click_button 'Sign in'
    end

    scenario "can watch site" do
      visit site_path(@site)
      click_button 'Watch this site'
      current_path.should eq site_path(@site)
      page.should have_content "You're now watching #{@site}"
      page.should have_content "1 person is watching this site"
    end

    scenario "can unwatch site" do
      visit site_path(@site)
      click_button 'Watch this site'
      current_path.should eq site_path(@site)
      click_button 'Stop watching'
      current_path.should eq site_path(@site)
      page.should have_content "You've stopped watching #{@site}"
      page.should have_content "Nobody, yet. You could be the first!"
    end

    scenario "page shows watched sites" do
      visit user_path(@user)
      page.should have_content "is not watching any sites"
      visit site_path(@site)
      click_button 'Watch this site'
      current_path.should eq site_path(@site)
      visit user_path(@user)
      page.should have_content "is watching 1 site"
      page.should have_content @site.to_s
      click_link "Stop watching"
      current_path.should eq user_path(@user)
      page.should have_content "is not watching any sites"
    end
  end

  context "any visitor" do
    before(:each) do
      @site = FactoryGirl.create(:site)
    end

    scenario "can't watch sites" do
      visit site_path(@site)
      page.should_not have_content "Watch this site"
    end
  end
end
