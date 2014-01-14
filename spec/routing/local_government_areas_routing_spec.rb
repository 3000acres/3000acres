require "spec_helper"

describe LocalGovernmentAreasController do
  describe "routing" do

    it "routes to #index" do
      get("/local_government_areas").should route_to("local_government_areas#index")
    end

    it "routes to #new" do
      get("/local_government_areas/new").should route_to("local_government_areas#new")
    end

    it "routes to #show" do
      get("/local_government_areas/1").should route_to("local_government_areas#show", :id => "1")
    end

    it "routes to #edit" do
      get("/local_government_areas/1/edit").should route_to("local_government_areas#edit", :id => "1")
    end

    it "routes to #create" do
      post("/local_government_areas").should route_to("local_government_areas#create")
    end

    it "routes to #update" do
      put("/local_government_areas/1").should route_to("local_government_areas#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/local_government_areas/1").should route_to("local_government_areas#destroy", :id => "1")
    end

  end
end
