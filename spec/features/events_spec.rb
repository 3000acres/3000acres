require 'spec_helper'

feature "events" do
  include UIHelper

  let(:user_event) { FactoryGirl.build(:event, name: 'First event!', id: 11, start_time: "2015-01-02T14:30:00+1000", end_time: "2015-01-02T16:00:00+1000") }
  let(:acres_event) { FactoryGirl.build(:event, name: 'Acres foo event', id: 22, start_time: "2015-02-01T14:30:00+1000", end_time: "2015-02-01T16:00:00+1000") }
  let(:empty_event) { { "id" => 33, "name" => "Empty event", start_time: "2015-02-01T14:30:00+1000", } }
  let(:nil_event) { {} }

  before(:each) do
    Graph.stub(:get_graph_events) do |id|
      case id
      when 1
        [ user_event ]
      when 2
        [ acres_event ]
      when 3
        [ empty_event ]
      when 4
        [ nil_event ]
      end
    end
    log_in
  end

  describe "events page" do
    scenario "user should see sites facebook events on events page" do
      setup_site
      fill_in 'Facebook', :with => 'http://facebook.com/acres1'
      click_button 'Create Site'
      visit '/events'
      expect(page.find('//h1.title')).to have_content 'Events'
      expect(page).to have_content 'First event!'
      expect(page).to have_content "Some Community Garden"
      expect(page).to have_content "Brunswick"
      expect(page).to have_content "33 James st"
      expect(page).to have_content "Test"
      expect(page).to have_css("//a[@href = '/sites/1-smith-st-smithville']")
      expect(page).to have_css("//img[@src = 'http://some_image.com/image']")
      expect(page).to have_content 'Friday, January 02 at 02:30PM - 04:00PM'
    end

    scenario "user should see acres facebook events on events page" do
      Figaro.env.stub(:acres_fb_id).and_return(2)
      Figaro.env.stub(:acres_site_name).and_return("acres")
      Figaro.env.stub(:acres_host).and_return("http://www.acres.org")
      visit '/events'
      expect(page).to have_content 'Acres foo event'
      expect(page).to have_content "Sunday, February 01 at 02:30PM - 04:00PM"
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

  pending "site show page" do
    scenario "user should see facebook events on sites page" do
      setup_site
      fill_in 'Facebook', :with => 'http://facebook.com/acres1'
      click_button 'Create Site'
      expect(page.find('//h2')).to have_content 'Events'
      expect(page).to have_content 'First event!'
      expect(page).to have_content "Test"
      expect(page).to have_css("//img[@src = 'http://some_image.com/image']")
      expect(page).to have_content "Friday, January 02 at 02:30PM - 04:00PM"
    end
  end
end

