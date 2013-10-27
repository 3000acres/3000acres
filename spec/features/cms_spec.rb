require 'spec_helper'

feature "cms admin" do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  scenario "cms admin requires login" do
    visit cms_admin_path
    # you'll be redirected to sign in
    current_path.should == new_user_session_path
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => @user.password
    click_button 'Sign in'
    # match any CMS admin page, since it sends you somewhere specific eg
    # /sites/1/pages/new
    current_path.should match /#{cms_admin_path}/
  end
end
