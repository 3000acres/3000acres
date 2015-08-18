shared_examples "location" do

  context "address" do
    it 'address is required' do
      expect(FactoryGirl.build(:site)).to be_valid
      expect(FactoryGirl.build(:site, :address => nil)).not_to be_valid
    end

    it 'suburb is required' do
      expect(FactoryGirl.build(:site)).to be_valid
      expect(FactoryGirl.build(:site, :suburb => nil)).not_to be_valid
    end
  end

  context "geocoding" do
    it 'has a full address' do
      address = "1 Smith St"
      suburb = "Smithville"
      Acres::Application.config.region = "Smithlandia"
      @site = FactoryGirl.build(:site, :address => address, :suburb => suburb)
      expect(@site.full_address).to eq "1 Smith St, Smithville, Smithlandia"
    end
  end
end
