require 'spec_helper'
require 'pp'

feature "nearby" do

  context "sites" do
    before(:each) do
      @admin_user = FactoryGirl.create(:admin_user)
      @user1 = FactoryGirl.create(:user, name: "Foobie")
      @user2 = FactoryGirl.create(:user, name: "Bar")
      @user3 = FactoryGirl.create(:user, name: "Doobie_Smith")
      @user4 = FactoryGirl.create(:user, name: "Dahby_Jones")
      @admin_site = FactoryGirl.create(
        :site, 
        name: "Admins site",
        address: "99 Burke st", 
        added_by_user: @admin_user, 
        latitude: "-37.7732084", 
        longitude: "144.84887760000004"
      )
      @near_site = FactoryGirl.create(
        :site, 
        name: "Users nearby site",
        address: "109 Burke st", 
        added_by_user: @user1, 
        latitude: "-37.7732084", 
        longitude: "144.84887760000004"
      )
      @far_site = FactoryGirl.create(
        :site, 
        name: "Users far site",
        address: "80 High st", 
        suburb: "Thornbury", 
        added_by_user: @user2, 
        latitude: "-37.7802946",
        longitude: "144.99694739999995"
      )
      @watch_near = FactoryGirl.create(:watch, user: @user3, site:@near_site)
      @watch_far = FactoryGirl.create(:watch, user: @user4, site:@far_site)
    end

    scenario "admin user should see nearby sites and watching users for nearby sites" do
      pp @far_site
      pp @near_site
      visit root_path
      click_link 'navbar-signin'
      fill_in 'Login', :with => @admin_user.email
      fill_in 'Password', :with => @admin_user.password
      click_button 'Sign in'
      visit site_path(@admin_site)
      expect(page).to have_css "#nearby_sites"
      expect(page).to have_content "109 Burke st"
      expect(page).to_not have_content "80 High st"
      expect(page).to have_content "Watching nearby"
      expect(page).to have_content "Doobie_Smith"
      expect(page).to_not have_content "Dahby_Jones"
    end

    scenario "logged in user should see nearby sites but not watching users" do
      visit root_path
      click_link 'navbar-signin'
      fill_in 'Login', :with => @user1.email
      fill_in 'Password', :with => @user1.password
      click_button 'Sign in'
      visit site_path(@admin_site)
      expect(page).to have_css "#nearby_sites"
      expect(page).to have_content "109 Burke st"
      expect(page).to_not have_content "80 High st"
      expect(page).to_not have_content "Watching nearby"
      expect(page).to_not have_content "Doobie_Smith"
    end
  end

  context "no nearby sites" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @site = FactoryGirl.create(
        :site, 
        name: "Admins site",
        address: "99 Burke st", 
        added_by_user: @user, 
        latitude: "-37.7732084", 
        longitude: "144.84887760000004"
      )
    end

    scenario "nearby sites should not show" do
      visit root_path
      click_link 'navbar-signin'
      fill_in 'Login', :with => @user.email
      fill_in 'Password', :with => @user.password
      click_button 'Sign in'
      visit site_path(@site)
      expect(page).to_not have_css "#nearby_sites"
    end
  end
end

