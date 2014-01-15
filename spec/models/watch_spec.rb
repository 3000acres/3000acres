require 'spec_helper'

describe Watch do
  before :each do
    @w = FactoryGirl.create(:watch)
  end

  it "exists" do
    @w.should be_an_instance_of Watch
  end

  it "has associations" do
    @w.user.should be_an_instance_of User
    @w.site.should be_an_instance_of Site
  end

end
