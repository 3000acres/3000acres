require 'spec_helper'

describe Site do

  context "geocoding" do
    it 'has a full address' do
      address = "1 Smith St"
      suburb = "Smithville"
      Acres::Application.config.region = "Smithlandia"
      site = FactoryGirl.create(:site, :address => address, :suburb => suburb)
      site.full_address.should eq "1 Smith St, Smithville, Smithlandia"
    end
  end

  context "required fields" do
    it 'address is required' do
      site = FactoryGirl.build(:site)
      site.should be_valid
      site = FactoryGirl.build(:site, :address => nil)
      site.should_not be_valid
    end

    it 'suburb is required' do
      site = FactoryGirl.build(:site)
      site.should be_valid
      site = FactoryGirl.build(:site, :suburb => nil)
      site.should_not be_valid
    end

    context 'status' do
      before(:each) do
        @site = FactoryGirl.create(:site)
      end

      it 'should have a status' do
        @site.status.should eq 'unknown'
      end

      it 'all valid status values should work' do
        ['unknown', 'suitable', 'unsuitable', 'in-progress', 'active'].each do |s|
          @site = FactoryGirl.build(:site, :status => s)
          @site.should be_valid
        end
      end

      it 'should refuse invalid status values' do
        @site = FactoryGirl.build(:site, :status => 'not valid')
        @site.should_not be_valid
        @site.errors[:status].should include("not valid is not a valid status")
      end
    end

  end
end
