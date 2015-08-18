shared_examples "watches" do

  context 'watches' do

    it "can watch a site" do
      @site = FactoryGirl.create(:site)
      expect {
        FactoryGirl.create(:watch, site: @site)
      }.to change { @site.watches.count }.by(1)
    end

    it "auto-watches site when added by a non-admin" do
      @user = FactoryGirl.create(:user)
      @site = FactoryGirl.create(:site, added_by_user: @user)
      @site.watches.count.should == 1
      @site.watches.last.user.should eq @user
    end

    it "auto-watches site when added by an admin" do
      @admin_user = FactoryGirl.create(:admin_user)
      @site = FactoryGirl.create(:site, added_by_user: @admin_user)
      @site.watches.count.should == 1
      @site.watches.last.user.should eq @admin_user
    end

  end

  context 'send_changed_email' do
    before do 
      @creating_user = FactoryGirl.create(:user, :send_email => false)
      @watching_user = FactoryGirl.create(:user, :send_email => true)
      @site = FactoryGirl.create(:site, added_by_user: @creating_user)
      FactoryGirl.create(:watch, :site => @site, :user => @watching_user)
    end

    it 'will send an email to watchers if changed' do
      expect(Mailer).to receive(:send_site_changed_notification!).with(@site, @watching_user)
      @site.name = "A new name"
    end

    it 'will not send email to watchers if unchanged' do 
      expect(Mailer).not_to receive(:send_site_changed_notification!)
      @site.name = @site.name
    end

    after { @site.save }
  end

end

