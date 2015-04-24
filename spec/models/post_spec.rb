require 'spec_helper'

describe Post do
  it "has a site and user" do
    @post = FactoryGirl.create(:post)
    @post.site.should be_an_instance_of Site
    @post.user.should be_an_instance_of User
  end

  it "should be ordered ascending, by creation date" do
    @post1 = FactoryGirl.create(:post, subject: "first")
    @post2 = FactoryGirl.create(:post, subject: "second")
    expect(Post.all.to_a).to eq [@post1, @post2]
  end

end
