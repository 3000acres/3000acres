require 'spec_helper'

describe Site do

  context "to_s" do
    it "uses the specified name if available" do
      site = FactoryGirl.build(:site, :name => 'AwesomeGarden')
      site.to_s.should eq "AwesomeGarden"
    end
    it "falls back to the address" do
      site = FactoryGirl.build(:site,
        :name => nil,
        :address => 'foo',
        :suburb => 'bar'
      )
      site.to_s.should eq "foo, bar"
    end
  end

  # Concerns separated out for slimmer specs.
  it_behaves_like "location"
  it_behaves_like "fb"
  it_behaves_like "nearby"
  it_behaves_like "notify"
  it_behaves_like "status"
  it_behaves_like "website"
  it_behaves_like "watches"
end
