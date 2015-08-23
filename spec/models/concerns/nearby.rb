shared_examples "nearby" do

  context "nearby sites" do
    before(:each) do
      @admin_user = FactoryGirl.create(:admin_user)
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @user3 = FactoryGirl.create(:user)
      @user4 = FactoryGirl.create(:user)
      @admin_site = FactoryGirl.create(:site, added_by_user: @admin_user)
      @near_site = FactoryGirl.create(:site, :near, added_by_user: @user1)
      @far_site = FactoryGirl.create(:site, :far, added_by_user: @user2)
      @watch_near = FactoryGirl.create(:watch, user: @user3, site:@near_site)
      @watch_far = FactoryGirl.create(:watch, user: @user4, site:@far_site)
    end

    it "should be in nearby_sites array, far sites should not" do
      expect(@admin_site.nearby_sites).to eq [@near_site]
    end

    it "near site watching users should be in nearby_users array, far sites watching users should not" do
      # User who created the site (user1) watches automatically.
      expect(@admin_site.nearby_users).to eq [@user1, @user3]
    end
  end

end
