require 'spec_helper'
require 'pp'

feature "nearby" do
  include UIHelper

  context "sites" do
    before(:each) do
      @admin_user = FactoryGirl.create(:admin_user)
      @user1 = FactoryGirl.create(:user, name: "Foobie_Chang")
      @user2 = FactoryGirl.create(:user, name: "Barbie_Nguyen")
      @user3 = FactoryGirl.create(:user, name: "Doobie_Smith")
      @user4 = FactoryGirl.create(:user, name: "Dahby_Jones")
      @admin_site = FactoryGirl.create(:site, added_by_user: @admin_user)
      @near_site = FactoryGirl.create(:site, :near, added_by_user: @user1)
      @far_site = FactoryGirl.create(:site, :far, added_by_user: @user2)
      @watch_near = FactoryGirl.create(:watch, user: @user3, site:@near_site)
      @watch_far = FactoryGirl.create(:watch, user: @user4, site:@far_site)
    end

    scenario "admin user should see nearby sites and watching users for nearby sites" do
      log_in_as_admin
      visit site_path(@admin_site)
      expect(page).to have_css "#nearby_sites"
      expect(page).to have_content "109 Burke st"
      expect(page).to_not have_content "80 High st"
      within('.admin.container') do
        expect(page).to have_content "Watching nearby"
        expect(page).to have_content "Foobie_Chang"
        expect(page).to have_content "Doobie_Smith"
        expect(page).to_not have_content "Barbie_Nguyen"
        expect(page).to_not have_content "Dahby_Jones"
      end
    end

    scenario "logged in user should see nearby sites but not watching users" do
      log_in
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
      @site = FactoryGirl.create(:site)
    end

    scenario "nearby sites block should not show" do
      log_in
      visit site_path(@site)
      expect(page).to_not have_css "#nearby_sites"
    end
  end
end

