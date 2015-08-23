require 'spec_helper'

describe Watch do
  before :each do
    @watch = FactoryGirl.create(:watch)
  end

  it "exists" do
    @watch.should be_an_instance_of Watch
  end

  it "has associations" do
    @watch.user.should be_an_instance_of User
    @watch.site.should be_an_instance_of Site
  end

end
