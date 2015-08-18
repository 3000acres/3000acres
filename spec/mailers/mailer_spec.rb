require "spec_helper"

describe Mailer do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:site) { FactoryGirl.create(:site, :added_by_user => user1) }

  context "site mail" do
    context "site_change_notification" do
      let(:mail) { Mailer.site_changed_notification(site, user2) }
      it "renders the subject" do
        expect(mail.subject).to eq "#{site.to_s}'s details were changed"
      end
      it "renders the receiver email" do
        expect(mail.to).to eq [user2.email]
      end
    end

    context "site_created_notification" do
      let(:mail) { Mailer.site_created_notification(site, user2) }
      it "renders the subject" do
        expect(mail.subject).to eq "#{site.to_s} was added"
      end
      it "renders the receiver email" do
        expect(mail.to).to eq [user2.email]
      end
    end

    context "site_created_thanks" do
      let(:mail) { Mailer.site_created_thanks(site, user2) }
      it "renders the subject" do
        expect(mail.subject).to eq "Thanks for adding #{site.to_s} to #{ENV['acres_site_name']}"
      end
      it "renders the receiver email" do
        expect(mail.to).to eq [user2.email]
      end
    end
  end

  context "new_watcher_notification" do
    let(:mail) { Mailer.new_watcher_notification(user1, site, user2) }
    it "renders the subject" do
      expect(mail.subject).to eq "Someone new is watching #{site.to_s} on #{ENV['acres_site_name']}"
    end
    it "renders the receiver email" do
      expect(mail.to).to eq [user2.email]
    end
  end

  context "post_created_notification" do
    let(:post) { FactoryGirl.create(:post, :user => user1, :site => site) }
    let(:mail) { Mailer.post_created_notification(post, user2) }
    it "renders the subject" do
      expect(mail.subject).to eq "#{post.user.name} posted #{post.subject} on #{post.site.to_s}"
    end
    it "renders the receiver email" do
      expect(mail.to).to eq [user2.email]
    end
  end
end
