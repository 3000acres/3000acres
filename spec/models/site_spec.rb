require 'spec_helper'

describe Site do

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
  end

end
