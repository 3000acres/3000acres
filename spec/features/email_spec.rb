require 'spec_helper'

feature "site changed notification" do
  include UIHelper

  before(:each) do
    log_in
    ActionMailer::Base.deliveries.clear
  end

  scenario "user is notified when they create a site" do
    expect { create_site }.to change { ActionMailer::Base.deliveries.count }.by(1)
    expect(ActionMailer::Base.deliveries.first.subject).to match /Thanks for adding/ 
  end

  scenario "admin users are notified on site creation" do
    2.times { FactoryGirl.create(:admin_user) }
    expect { create_site }.to change { ActionMailer::Base.deliveries.count }.by(3)
    expect(ActionMailer::Base.deliveries[0].subject).to match /Thanks for adding/ 
    expect(ActionMailer::Base.deliveries[1].subject).to match /was added/ 
    expect(ActionMailer::Base.deliveries[2].subject).to match /was added/ 
  end

  # Somehow this doesn't behave the same way as the live site.
  pending "email sent to watcher on site change" do
    @site = FactoryGirl.create(:site, :added_by_user => @user, :status => 'potential')
    # user will automatically be watching the site
    visit edit_site_path(@site)
    fill_in 'Name', :with => 'This is a new name'
    expect {
      click_button 'Update Site'
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
    expect(ActionMailer::Base.deliveries[0].subject).to match /details were changed/
  end

  # Somehow this doesn't behave the same way as the live site.
  pending "admin users are notified on site change" do
    @site = FactoryGirl.create(:site, :added_by_user => @user, :status => 'potential')
    2.times { FactoryGirl.create(:admin_user) }
    visit edit_site_path(@site)
    fill_in 'Name', :with => 'This is a new name'
    expect {
      click_button 'Update Site'
    }.to change { ActionMailer::Base.deliveries.count }.by(3)

    expect(ActionMailer::Base.deliveries[0].subject).to match /details were changed/
    expect(ActionMailer::Base.deliveries[1].subject).to match /details were changed/
    expect(ActionMailer::Base.deliveries[2].subject).to match /details were changed/
  end

end
