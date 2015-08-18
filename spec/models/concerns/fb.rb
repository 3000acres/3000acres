shared_examples_for "fb" do
  describe "fb", :shared => true do
    context "facebook" do
      it 'validates facebook' do
        @site = FactoryGirl.build(:site, :facebook => 'facebook.com/3000acres')
        expect(@site).to be_valid
        @site = FactoryGirl.build(:site, :facebook => '3000acres')
        expect(@site).to be_valid
      end
      it 'allows blank and nil facebook' do
        @site = FactoryGirl.build(:site, :facebook => '')
        expect(@site).to be_valid
        @site = FactoryGirl.build(:site, :facebook => nil)
        expect(@site).to be_valid
      end
      it 'normalises facebook if url is missing' do
        @site = FactoryGirl.build(:site, :facebook => '3000acres')
        expect(@site).to be_valid
        expect(@site.facebook).to eq 'http://facebook.com/3000acres'
      end
      it 'normalises facebook if first slash is included' do
        @site = FactoryGirl.build(:site, :facebook => '/3000acres')
        expect(@site).to be_valid
        expect(@site.facebook).to eq 'http://facebook.com/3000acres'
      end
      it "doesn't normalise facebook starting with http" do
        @site = FactoryGirl.build(:site, :facebook => 'http://facebook.com/3000acres')
        expect(@site).to be_valid
        expect(@site.facebook).to eq 'http://facebook.com/3000acres'
      end
      it "correctly normalises facebook when starting with facebook.com" do
        @site = FactoryGirl.build(:site, :facebook => 'facebook.com/3000acres')
        expect(@site).to be_valid
        expect(@site.facebook).to eq 'http://facebook.com/3000acres'
      end
      it "doesn't normalise blank facebook" do
        @site = FactoryGirl.build(:site, :facebook => '')
        expect(@site).to be_valid
        expect(@site.facebook).to eq ''
      end
      it "doesn't normalise nil facebook" do
        @site = FactoryGirl.build(:site, :facebook => nil)
        expect(@site).to be_valid
        expect(@site.facebook).to eq nil
      end
    end

    context 'facebook id' do
      # We mock id reteival by using a number from the url, see spec/factories/sites.rb.
      it "is retreived for a valid facebook page" do
        @site = FactoryGirl.build(:site, :facebook => "http://facebook.com/acres3")
        expect(@site).to be_valid
        expect(@site.facebook_id).to eq 3
      end
      it "invalidates when retreiving an invalid page" do
        @site = FactoryGirl.build(:site, :facebook => "http://facebook.com/acres")
        expect(@site).to_not be_valid
      end
    end
  end
end
