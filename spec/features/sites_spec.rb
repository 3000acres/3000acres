require 'spec_helper'

feature "add site" do

  context "admin user" do
    before(:each) do
      @admin_user = FactoryGirl.create(:admin_user)
      visit root_path
      click_link 'navbar-signin'
      fill_in 'Login', :with => @admin_user.email
      fill_in 'Password', :with => @admin_user.password
      click_button 'Sign in'
    end

    scenario "can add site" do
      visit root_path
      click_link "Sites Admin"
      click_link "New Site"
      fill_in 'Address', :with => '1 Smith St'
      fill_in 'Suburb', :with => 'Smithville'
      click_button 'Create Site'
      current_path.should eq site_path(Site.last)
    end

    scenario "add another button" do
      visit new_site_path
      fill_in 'Address', :with => '1 Smith St'
      fill_in 'Suburb', :with => 'Smithville'
      click_button 'Create Site'
      page.should have_content "Add another"
    end
  end

  context "signed in user" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      visit root_path
      click_link 'navbar-signin'
      fill_in 'Login', :with => @user.email
      fill_in 'Password', :with => @user.password
      click_button 'Sign in'
    end

    scenario "can add site" do
      visit root_path
      click_link "Add a site"
      fill_in 'Address', :with => '1 Smith St'
      fill_in 'Suburb', :with => 'Smithville'
      click_button 'Create Site'
      current_path.should eq site_path(Site.last)
    end

    scenario "can edit site if status is still unknown" do
      visit root_path
      click_link "Add a site"
      fill_in 'Address', :with => '1 Smith St'
      fill_in 'Suburb', :with => 'Smithville'
      click_button 'Create Site'
      current_path.should eq site_path(Site.last)
      page.should have_content "you can edit the details"
      click_link 'Edit'
      current_path.should eq edit_site_path(Site.last)
      click_button 'Update Site'
      current_path.should eq site_path(Site.last)
    end

    scenario "can't edit site once approved" do
      @site = FactoryGirl.create(:site, :status => 'potential', :added_by_user => @user)
      visit site_path(@site)
      expect { find_button("Edit") }.to raise_error
      page.should_not have_content "you can edit the details"
    end
  end

  context "any visitor" do
    before(:each) do
      @site = FactoryGirl.create(:site)
    end

    scenario "view site details" do
      visit site_path(@site)
      page.should have_content @site.to_s #heading
      page.should have_content @site.address
      page.should have_content @site.suburb
      page.should have_content @site.website
      page.should have_css('div#map')
    end

    scenario "site has a friendly url" do
      @site = FactoryGirl.create(:site, :address => '1 smith st', :suburb => 'jonestown')
      visit site_path(@site)
      current_path.should match /1-smith-st-jonestown/
    end

  end
end
