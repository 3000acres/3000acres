module UIHelper

  def log_in
    @user = FactoryGirl.create(:user) if @user.nil?
    visit root_path
    click_link 'navbar-signin'
    fill_in 'Login', :with => @user.email
    fill_in 'Password', :with => @user.password
    click_button 'Sign in'
  end

  def log_in_as_admin
    @admin_user = FactoryGirl.create(:admin_user) if @admin_user.nil?
    visit root_path
    click_link 'navbar-signin'
    fill_in 'Login', :with => @admin_user.email
    fill_in 'Password', :with => @admin_user.password
    click_button 'Sign in'
  end

  def create_site
    visit sites_path
    click_link "add-site"
    fill_in 'Address', :with => '1 Smith St'
    fill_in 'Suburb', :with => 'Smithville'
    click_button 'Create Site'
  end

  def setup_site
    visit sites_path
    click_link "add-site"
    fill_in 'Address', :with => '1 Smith St'
    fill_in 'Suburb', :with => 'Smithville'
  end

end
