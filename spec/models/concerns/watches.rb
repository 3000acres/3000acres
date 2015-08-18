shared_examples "watches" do

  context 'watches' do
    before(:each) do
      @site = FactoryGirl.create(:site)
    end

    it "can watch a site" do
      expect {
        FactoryGirl.create(:watch, site: @site)
      }.to change { @site.watches.count }.by(1)
    end

    it "auto-watches site when added by a non-admin" do
      @user = FactoryGirl.create(:user)
      @this_site = FactoryGirl.create(:site, added_by_user: @user)
      @this_site.watches.count.should == 1
      @this_site.watches.last.user.should eq @user
    end

    it "auto-watches site when added by an admin" do
      @admin_user = FactoryGirl.create(:admin_user)
      @new_site = FactoryGirl.create(:site, added_by_user: @admin_user)
      @new_site.watches.count.should == 1
      @new_site.watches.last.user.should eq @admin_user
    end
  end
end

