require 'spec_helper'

describe Post do

  it "has a site and user" do
    @post = FactoryGirl.create(:post)
    @post.site.should be_an_instance_of Site
    @post.user.should be_an_instance_of User
  end
end
