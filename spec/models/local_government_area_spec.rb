require 'spec_helper'

describe LocalGovernmentArea do

  context "stringification" do
    it "stringifies with its name" do
      site = FactoryGirl.build(:local_government_area, :name => 'Shire of Awesomeville')
      site.to_s.should eq "Shire of Awesomeville"
    end
  end

end
