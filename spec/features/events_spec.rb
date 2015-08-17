require 'spec_helper'

USER_EVENT = FactoryGirl.build(:event, name: 'First event!', id: 11, start_time: "2015-01-02T14:30:00+1000", end_time: "2015-01-02T16:00:00+1000")
ACRES_EVENT = FactoryGirl.build(:event, name: 'Acres foo event', id: 22, start_time: "2015-02-01T14:30:00+1000", end_time: "2015-02-01T16:00:00+1000")
EMPTY_EVENT = { "id" => 33, "name" => "Empty event", start_time: "2015-02-01T14:30:00+1000", }
NIL_EVENT = {}

feature "events" do
  include UIHelper

  before(:each) do
    Event.stub(:get_facebook_events) do |id|
      case id
      when 1
        [ USER_EVENT ]
      when 2
        [ ACRES_EVENT ]
      when 3
        [ EMPTY_EVENT ]
      when 4
        [ NIL_EVENT ]
      end
    end
    log_in
  end

  scenario "user should see sites facebook events" do
    setup_site
    fill_in 'Facebook', :with => 'http://facebook.com/acres1'
    click_button 'Create Site'
    user_event_obj = Event.hash_to_object(Event.add_site_data(USER_EVENT, Site.last.to_s, site_path(Site.last)))
    visit '/events'
    expect(page.find('//h1.title')).to have_content 'Events'
    expect(page).to have_content 'First event!'
    expect(page).to have_content "Some Community Garden"
    expect(page).to have_content "Brunswick"
    expect(page).to have_content "33 James st"
    expect(page).to have_content "Test"
    expect(page).to have_css("//a[@href = '#{user_event_obj.site.url}']")
    expect(page).to have_css("//img[@src = '#{user_event_obj.cover.source}']")
    expect(page).to have_content user_event_obj.times
  end

  scenario "user should see acres facebook events" do
    Figaro.env.stub(:acres_fb_id).and_return(2)
    Figaro.env.stub(:acres_site_name).and_return("acres")
    Figaro.env.stub(:acres_host).and_return("http://www.acres.org")
    acres_event_obj = Event.hash_to_object(Event.add_site_data(ACRES_EVENT, Figaro.env.acres_site_name, Figaro.env.acres_host))
    visit '/events'
    expect(page).to have_content 'Acres foo event'
    expect(page).to have_content acres_event_obj.times
  end

  scenario "page should handle events missing any fields" do
    setup_site
    fill_in 'Facebook', :with => 'http://facebook.com/acres3'
    click_button 'Create Site'
    visit '/events'
    expect(page).to have_content 'Empty event'
  end

  scenario "page should handle nil events" do
    setup_site
    fill_in 'Facebook', :with => 'http://facebook.com/acres4'
    click_button 'Create Site'
    visit '/events'
    expect(page.find('//h1.title')).to have_content 'Events'
  end
end

