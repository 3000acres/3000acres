require 'spec_helper'

def expect_matching_ids(objects)
  expect(Event.all.map {|e| e.id }).to eq objects.map {|o| o.id }
end

describe Event do
  before(:each) do
    # Stub the get_facebook_events call and return our prebuilt hashes instead.
    Graph.stub(:get_graph_events) do |id|
      case id
      when 1
        # Mock a page with one event.
        [ event1 ]
      when 2
        # Mock a page with two events.
        [ event22, event21 ]
      when 3
        [ acres_event ]
      end
    end
  end

  let(:event1)      { FactoryGirl.build(:event, id: 11, start_time: "2015-01-01T14:30:00+1000", end_time: "2015-01-01T16:00:00+1000") }
  let(:event21)     { FactoryGirl.build(:event, id: 21, start_time: "2015-02-01T14:30:00+1000", end_time: "2015-02-01T16:00:00+1000") }
  let(:event22)     { FactoryGirl.build(:event, id: 22, start_time: "2015-02-02T14:30:00+1000", end_time: "2015-02-02T16:00:00+1000") }
  let(:acres_event) { FactoryGirl.build(:event, id: 33, start_time: "2015-03-01T14:30:00+1000", end_time: "2015-03-01T16:00:00+1000") }
  let(:ob1)         { Event.hash_to_object(event1) }
  let(:ob21)        { Event.hash_to_object(event21) }
  let(:ob22)        { Event.hash_to_object(event22) }
  let(:acres_ob)    { Event.hash_to_object(acres_event) }

  let(:events) do 
    [{
      "id" => 99,
      "name" => "Bar event",
      "cover" => {"source" => "http://some_image.com/image"},
      "place" => {
        "name" => "Foo gardens",
        "location" => {"city" => "Brunswick", "street" => "33 James st"}
      },
      "description" => "Test description",
      "start_time" => "2015-03-01T14:30:00+1000",
      "end_time" => "2015-03-01T16:00:00+1000"
    }]
  end
  let(:event_object) do 
    hash = {
      "id" => 99,
      "name" => "Bar event",
      "cover" => { "source" => "http://some_image.com/image"},
      "place" => {
        "name" => "Foo gardens",
        "location" => {"city" => "Brunswick", "street" => "33 James st"}
      },
      "description" => "Test description",
      "start_time" => "2015-03-01T14:30:00+1000",
      "end_time" => "2015-03-01T16:00:00+1000",
      "site" => {
        "name" => "Foo gardens", 
        "url" => "/sites/33-james-st-brunswick"
      }
    }
    Event.hash_to_object(hash)
  end
  let(:past_events) do 
    [{
      "id" => 73,
      "name" => "Bar event",
      "cover" => {"source" => "http://some_image.com/image"},
      "place" => {
        "name" => "Ye olde gardens",
        "location" => {"city" => "Oldtown", "street" => "Ye olde place"}
      },
      "description" => "Test description",
      "start_time" => "1873-03-01T14:30:00+1000",
      "end_time" => "1873-03-01T16:00:00+1000"
    }]
  end
  let(:empty_events) { [] }

  context "build_events" do

    it 'can return events as objects' do
      ob = event_object
      expect(Event.build_events(events, "Foo gardens", "/sites/33-james-st-brunswick")).to eq [ob]
    end

    it 'can handle an empty events array' do
      expect(Event.build_events(empty_events, "Foo gardens", "/sites/33-james-st-brunswick")).to eq []
    end

    it 'doesnt show past events' do
      expect(Event.build_events(past_events, "Ye olde gardens", "/sites/ye-olde-place-oldtown")).to eq []
    end

  end

  context "all" do

    it 'lists events for the acres facebook page' do
      Figaro.env.stub(:acres_fb_id).and_return(3)
      # The acres facebook page can have id of 3.
      expect(Event.all[0].id).to eq acres_ob.id
    end

    it 'lists events for all sites with a facebook_id, in ascending order by start_time' do
      @site1 = FactoryGirl.create(:site, :facebook => 'facebook.com/site1')
      @site2 = FactoryGirl.create(:site, :facebook => 'facebook.com/site2')
      expect(@site1.facebook_id).to eq 1
      expect_matching_ids([ob1, ob21, ob22])
    end

    it 'lists all events for all sites and acres, in ascending order' do
      Figaro.env.stub(:acres_fb_id).and_return(3)
      @site1 = FactoryGirl.create(:site, :facebook => 'facebook.com/site1')
      @site2 = FactoryGirl.create(:site, :facebook => 'facebook.com/site2')
      expect(@site1.facebook_id).to eq 1
      expect_matching_ids([ ob1, ob21, ob22, acres_ob ])
    end
  end

  pending 'page_events' do 
    it "lists all events for a specific facebook id" do
      @site2 = FactoryGirl.create(:site, :facebook => 'facebook.com/site2')
      expect(Event.page_events(@site2.facebook_id).map {|e| e.id }).to eq [ob21, ob22].map {|o| o.id } 
    end
  end
end
