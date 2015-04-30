# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
    transient do
      latitude 1
      longitude 1
    end
    name "Awesome Community Garden"
    description "This is a great food garden..."
    address "99 Bourke St"
    suburb "Melbourne"
    size "9.99"
    water false
    available_until "2013-11-08"
    status "potential"
    local_government_area
    added_by_user
    website 'http://example.com'

    # add association equal to state code
    after(:build) do |site, evaluator|
      site.stub(:geocode)
      site.latitude = evaluator.latitude
      site.longitude = evaluator.longitude
    end
  end
end
