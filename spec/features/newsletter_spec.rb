require 'spec_helper'

feature "newsletter" do
  scenario "sign up form includes newsletter checkbox" do
    visit root_path
    click_link 'navbar-signup'
    page.should have_content("Newsletter")
  end

  scenario "edit account includes newsletter checkbox" do
    @user = FactoryGirl.create(:user)
    visit root_path
    click_link 'navbar-signin'
    fill_in 'Login', :with => @user.email
    fill_in 'Password', :with => @user.password
    click_button 'Sign in'
    click_link 'Edit account'
    page.should have_content("Newsletter")
  end
end

