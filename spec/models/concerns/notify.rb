shared_examples "notify" do
 before(:each) do
    @user = FactoryGirl.create(:user)
  end

  context 'send_created_nofification' do
    it 'will send creator an email when created' do
      expect(Mailer).to receive(:site_created_thanks).once #with(anything(), @user)
      FactoryGirl.create(:site, added_by_user: @user)
    end
  end

  context 'send_created_admin_email' do
    it 'will send admins email when created' do
      @admin_user = FactoryGirl.create(:admin_user)
      expect(Mailer).to receive(:site_created_notification).and_return(double("mailer", :deliver => true))
      FactoryGirl.create(:site, added_by_user: @user)
    end

    it 'will send emails to multiple admins when created' do
      @admin_user1 = FactoryGirl.create(:admin_user)
      @admin_user2 = FactoryGirl.create(:admin_user)
      expect(Mailer).to receive(:site_created_notification).with(anything(), @admin_user1)
      expect(Mailer).to receive(:site_created_notification).with(anything(), @admin_user2)
      FactoryGirl.create(:site, added_by_user: @user)
    end
  end

  context 'send_changed_admin_email' do
    it 'will send admins email if there are changes' do
      @site = FactoryGirl.create(:site, added_by_user: @user)
      @site.name = "A new name"
      expect(@site.save).to change{ ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'wont send admins email if update contains no changes' do 
      @admin_user = FactoryGirl.create(:admin_user)
      expect(Mailer).to receive(:site_changed_notification).with(anything(), @admin_user)
      FactoryGirl.create(:site, added_by_user: @user)
    end

  end

end
