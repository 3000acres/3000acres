require 'spec_helper'

feature "sites" do
  include UIHelper
  context "admin user" do
    before(:each) do
      log_in_as_admin
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
      create_site
      page.should have_content "Add another"
    end

    scenario "can set featured sites to show on front page" do
      visit new_site_path
      expect(page).to have_css "input#site_featured"
      setup_site
      fill_in 'Name', :with => 'Foos garden'
      check "site_featured"
      click_button 'Create Site'
      visit root_path
      expect(page).to have_content "Foos garden"
    end
    
    scenario "can see admin panel on sites index page" do
      visit sites_path
      expect(page).to have_content "Admin"
    end

    scenario "can see admin panel and watching emails on site show page" do
      create_site
      expect(page).to have_content "Admin"
      expect(page).to have_content @admin_user.email
    end
  end

  context "signed in user" do
    before(:each) do
      log_in
    end

    scenario "can add site" do
      create_site 
      current_path.should eq site_path(Site.last)
    end

    scenario "can edit site if status is still potential" do
      create_site 
      current_path.should eq site_path(Site.last)
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

    scenario "can add website without leading http://" do
      setup_site
      fill_in 'Website', :with => 'example.com'
      click_button 'Create Site'
      page.should have_content 'Website: http://example.com'
    end

    scenario "can add facebook without facebook.com/" do
      setup_site
      fill_in 'Facebook', :with => '3000acres'
      click_button 'Create Site'
      expect(page).to have_xpath "//div[@data-href='http://facebook.com/3000acres']"
    end

    scenario "can't set featured check" do
      visit new_site_path
      expect(page).not_to have_css "input#site_featured"
    end

    scenario "can add a site image" do
      setup_site
      attach_file "site_image", 'spec/fixtures/images/test.png'  
      click_button 'Create Site'
      expect(page).to have_xpath "//img[@alt='Test']"
    end

    scenario "can't see admin panel on sites index page" do
      visit sites_path
      expect(page).not_to have_content "Admin"
    end

    scenario "can't see admin panel or watching emails on site show page" do
      create_site
      current_path.should eq site_path(Site.last)
      expect(page).not_to have_content "Admin"
      expect(page).not_to have_content @user.email
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

    scenario "water does not show if nil" do
      @site = FactoryGirl.create(:site, :water => nil)
      visit site_path(@site)
      page.should_not have_content "Water available?"
    end

    scenario "get-involved details shows if contact is nil" do
      @site = FactoryGirl.create(:site, :contact => nil)
      visit site_path(@site)
      expect(page).to have_css "div.get-involved-details"
    end

    scenario "contact details show if not nil, without get-involved details" do
      @site = FactoryGirl.create(:site, :contact => "Bob Foos contact details")
      visit site_path(@site)
      expect(page).to_not have_css "div.get-involved-details"
      expect(page).to have_content "Bob Foos contact details"
    end

  end
end
