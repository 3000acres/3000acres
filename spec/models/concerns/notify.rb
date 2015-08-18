shared_examples "notify" do

  before(:each) do
    @user = FactoryGirl.create(:user, :send_email => false)
  end

  context 'send_created_nofification' do

    it 'will send creator an email when created' do
      @wants_email_user = FactoryGirl.create(:user, :send_email => true)
      expect(Mailer).to receive(:send_site_created_thanks!).once.with(anything(), @wants_email_user)
      FactoryGirl.create(:site, added_by_user: @wants_email_user)
    end

    it 'wont send creator an email when created if send_email is false' do
      @no_email_user = FactoryGirl.create(:user, :name => "no_email_man", :send_email => false)
      expect(Mailer).not_to receive(:send_site_created_thanks!)
      FactoryGirl.create(:site, added_by_user: @no_email_user)
    end
  end

  context 'send_created_admin_email' do
    after { FactoryGirl.create(:site, added_by_user: @user) }

    it 'will not send email to normal users' do
      @user2 = FactoryGirl.create(:user)
      expect(Mailer).not_to receive(:send_site_created_notification!)
    end

    it 'will send email to admin user when created' do
      @admin_user = FactoryGirl.create(:admin_user)
      expect(Mailer).to receive(:send_site_created_notification!).once.with(anything(), @admin_user)
    end

    it 'will send emails to multiple admins when created' do
      @admin_user1 = FactoryGirl.create(:admin_user)
      @admin_user2 = FactoryGirl.create(:admin_user)
      expect(Mailer).to receive(:send_site_created_notification!).twice
    end
  end

  context 'send_changed_admin_email' do
    before { @site = FactoryGirl.create(:site, added_by_user: @user) }
    after { @site.save }

    it 'will not send email to normal users' do
      @normal_user = FactoryGirl.create(:user)
      expect(Mailer).not_to receive(:send_site_changed_notification!).with(anything(), @normal_user)
      @site.name = "A new name"
    end

    it 'will send email to admin user if there are changes' do
      @admin_user = FactoryGirl.create(:admin_user)
      expect(Mailer).to receive(:send_site_changed_notification!).once.with(anything(), @admin_user)
      @site.name = "A new name"
    end

    it 'wont send email to admin user if update contains no changes' do 
      @admin_user = FactoryGirl.create(:admin_user)
      expect(Mailer).not_to receive(:send_site_changed_notification!)
      @site.name = @site.name
    end

  end

end
