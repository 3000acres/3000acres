require 'spec_helper'

feature "add site" do

  context "admin user" do
    before(:each) do
      @admin_user = FactoryGirl.create(:admin_user)
      visit root_path
      click_link 'Sign in'
      fill_in 'Email', :with => @admin_user.email
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
    end

  end
end
