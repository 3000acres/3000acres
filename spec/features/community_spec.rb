require 'spec_helper'

feature "post" do
  context "signed in user" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      visit root_path
      click_link 'navbar-signin'
      fill_in 'Login', :with => @user.email
      fill_in 'Password', :with => @user.password
      click_button 'Sign in'
      visit sites_path
      click_link "add-site"
      fill_in 'Address', :with => '1 Smith St'
      fill_in 'Suburb', :with => 'Smithville'
      click_button 'Create Site'
      @site = Site.last
    end

    scenario "post form appears on site page" do
      visit site_path(@site)
      expect(page).to have_selector("input[value='Post']")
    end

    context "posting an update about a site" do
      before :each do
        visit site_path(@site)
        fill_in "post_body", :with => "Here is some news about the garden. It's *awesome*."
        click_button "Post"
        @post = Post.last
      end

      scenario "post appears on site page" do
        current_path.should eq site_path(@site)
        page.should have_content "Here is some news"
        page.should have_content "#{@user.name} on"
      end

      # scenario "markdown help" do
      #   page.should have_content "You can use Markdown"
      # end

      # scenario "post includes rendered markdown" do
      #   page.should_not have_content "*awesome*"
      #   page.should have_selector "em", :text => "awesome"
      # end

      scenario "posts listed on user profile" do
        visit user_path(@user)
        page.should have_content "Discussion posts"
        page.should have_content @post.subject
      end

    end
  end
end
