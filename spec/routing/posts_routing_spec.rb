require "spec_helper"

describe PostsController do
  describe "routing" do

    it "routes to #create" do
      post("/posts").should route_to("posts#create")
    end

  end
end
