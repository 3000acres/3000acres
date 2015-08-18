require 'spec_helper'

feature "site changed notification" do
  include UIHelper

  before(:each) do
    log_in
  end

  scenario "user is notified when they create a site" do
    expect { create_site }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  scenario "admin users are notified on site creation" do
    2.times { FactoryGirl.create(:admin_user) }
    expect { create_site }.to change { ActionMailer::Base.deliveries.count }.by(3)
  end

  scenario "email sent to watcher on site change" do
    @site = FactoryGirl.create(:site, :added_by_user => @user, :status => 'potential')
    # user will automatically be watching the site
    visit edit_site_path(@site)
    fill_in 'Name', :with => 'This is a new name'
    expect {
      click_button 'Update Site'
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  scenario "admin users are notified on site change" do
    @site = FactoryGirl.create(:site, :added_by_user => @user, :status => 'potential')
    2.times { FactoryGirl.create(:admin_user) }
    visit edit_site_path(@site)
    fill_in 'Name', :with => 'This is a new name'
    expect {
      click_button 'Update Site'
    }.to change { ActionMailer::Base.deliveries.count }.by(3)
  end

end
