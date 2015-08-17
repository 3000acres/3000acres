require 'spec_helper'

EVENT1 = FactoryGirl.build(:event, id: 11, start_time: "2015-01-01T14:30:00+1000", end_time: "2015-01-01T16:00:00+1000")
EVENT21 = FactoryGirl.build(:event, id: 21, start_time: "2015-02-01T14:30:00+1000", end_time: "2015-02-01T16:00:00+1000")
EVENT22 = FactoryGirl.build(:event, id: 22, start_time: "2015-02-02T14:30:00+1000", end_time: "2015-02-02T16:00:00+1000")
ACRES_EVENT = FactoryGirl.build(:event, id: 33, start_time: "2015-03-01T14:30:00+1000", end_time: "2015-03-01T16:00:00+1000")
OB1  = Event.hash_to_object(EVENT1)
OB21 = Event.hash_to_object(EVENT21)
OB22 = Event.hash_to_object(EVENT22)
ACRES_OB = Event.hash_to_object(ACRES_EVENT) 

def expect_matching_ids(objects)
  expect(Event.all.map {|e| e.id }).to eq objects.map {|o| o.id }
end

describe Event do

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

  context "get_facebook_events" do

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

    before(:each) do
      # Stub the get_facebook_events call and return our prebuilt hashes instead.
      Event.stub(:get_facebook_events) do |id|
        case id
        when 1
          # Mock a page with one event.
          [ EVENT1 ]
        when 2
          # Mock a page with two events.
          [ EVENT22, EVENT21 ]
        when 3
          [ ACRES_EVENT ]
        end
      end
    end

    it 'lists events for the acres facebook page' do
      Figaro.env.stub(:acres_fb_id).and_return(3)
      # The acres facebook page can have id of 3.
      expect(Event.all[0].id).to eq ACRES_OB.id
    end

    it 'lists events for all sites with a facebook_id, in ascending order by start_time' do
      @site1 = FactoryGirl.create(:site, :facebook => 'facebook.com/site1')
      @site2 = FactoryGirl.create(:site, :facebook => 'facebook.com/site2')
      expect(@site1.facebook_id).to eq 1
      expect_matching_ids([OB1, OB21, OB22])
    end

    it 'lists all events for all sites and acres, in ascending order' do
      Figaro.env.stub(:acres_fb_id).and_return(3)
      @site1 = FactoryGirl.create(:site, :facebook => 'facebook.com/site1')
      @site2 = FactoryGirl.create(:site, :facebook => 'facebook.com/site2')
      expect(@site1.facebook_id).to eq 1
      expect_matching_ids([ OB1, OB21, OB22, ACRES_OB ])
    end

  end
end
