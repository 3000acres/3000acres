require 'spec_helper'

EVENT1 = FactoryGirl.build(:event, id: 11, start_time: "2015-01-01T14:30:00+1000", end_time: "2015-01-01T16:00:00+1000")
EVENT21 = FactoryGirl.build(:event, id: 21, start_time: "2015-02-01T14:30:00+1000", end_time: "2015-02-01T16:00:00+1000")
EVENT22 = FactoryGirl.build(:event, id: 22, start_time: "2015-02-02T14:30:00+1000", end_time: "2015-02-02T16:00:00+1000")
EVENT3 = FactoryGirl.build(:event, id: 33, start_time: "2015-03-01T14:30:00+1000", end_time: "2015-03-01T16:00:00+1000")
O1  = Event.hash_to_object(EVENT1)
O21 = Event.hash_to_object(EVENT21)
O22 = Event.hash_to_object(EVENT22)
O3  = Event.hash_to_object(EVENT3) 

describe Event do
  before(:each) do
    # Stub the get_facebook_events call and return our prebuilt hashes instead.
    Event.stub(:get_facebook_events) do |id|
      case id
      when 1
        [ EVENT1 ]
      when 2
        [ EVENT22, EVENT21 ]
      when 3
        [ EVENT3 ]
      end
    end

  end

  context "get facebook events" do
    it 'lists events for the acres faceook page' do
      Figaro.env.stub(:acres_fb_id).and_return(3)
      # The acres facebook page can have id of 3.
      expect(Event.all[0].id).to eq O3.id
    end

    it 'lists events for all sites with a facebook_id, in ascending order by start_time' do
      @site1 = FactoryGirl.create(:site, :facebook => 'facebook.com/site1')
      @site2 = FactoryGirl.create(:site, :facebook => 'facebook.com/site2')
      expect(@site1.facebook_id).to eq 1
      # Match by ids.
      expect(Event.all.map {|e| e.id }).to eq [ O1, O21, O22 ].map {|e| e.id }
    end

    it 'can handle pages with no events' do
      Figaro.env.stub(:acres_fb_id).and_return(9)
      @site1 = FactoryGirl.create(:site, :facebook => 'facebook.com/site1')
      @site99 = FactoryGirl.create(:site, :facebook => 'facebook.com/site99')
      # Match by ids.
      expect(Event.all.map {|e| e.id }).to eq [ O1 ].map {|e| e.id }
    end


    it 'lists all events for all sites and acres, in ascending order' do
      Figaro.env.stub(:acres_fb_id).and_return(3)
      @site1 = FactoryGirl.create(:site, :facebook => 'facebook.com/site1')
      @site2 = FactoryGirl.create(:site, :facebook => 'facebook.com/site2')
      expect(@site1.facebook_id).to eq 1
      # Match by ids.
      expect(Event.all.map {|e| e.id }).to eq [ O1, O21, O22, O3 ].map {|e| e.id }
    end

  end

end
