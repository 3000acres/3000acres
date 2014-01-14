require 'spec_helper'

feature "newsletter" do
  scenario "footer includes newsletter signup" do
    visit root_path
    find('#newsletter-footer').should have_content "Subscribe to our newsletter"
    find('#newsletter-footer').should have_field "EMAIL"
  end

  scenario "sign up form includes newsletter checkbox" do
    visit root_path
    click_link 'Sign up'
    page.should have_content("Newsletter")
  end

  scenario "edit account includes newsletter checkbox" do
    @user = FactoryGirl.create(:user)
    visit root_path
    click_link 'Sign in'
    fill_in 'Login', :with => @user.email
    fill_in 'Password', :with => @user.password
    click_button 'Sign in'
    click_link 'Edit account'
    page.should have_content("Newsletter")
  end
end

