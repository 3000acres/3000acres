require 'spec_helper'

describe "LocalGovernmentAreas" do
  describe "GET /local_government_areas" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get local_government_areas_path
      response.status.should be(200)
    end
  end
end
