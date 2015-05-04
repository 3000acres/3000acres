# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
    description "This is a great food garden..."
    size "9.99"
    water false
    available_until "2013-11-08"
    status "potential"
    local_government_area
    added_by_user
    website 'http://example.com'
    name "Awesome Community Garden"
    address "99 Bourke St"
    suburb "Melbourne"
    latitude "-37.7732084" 
    longitude "144.84887760000004"

    trait :near do
      name "Nearby site"
      address "109 Burke st" 
      suburb "Melbourne"
      latitude "-37.7732084" 
      longitude "144.84887760000004"
    end

    trait :far do
      name "Far site"
      address "80 High st" 
      suburb "Thornbury" 
      latitude "-37.7802946"
      longitude "144.99694739999995"
    end

    # Stub external services.
    after(:build) do |site, evaluator|
      site.stub(:geocode)
      site.latitude = evaluator.latitude
      site.longitude = evaluator.longitude
      
      site.stub(:get_facebook_page){ { 'name' => 'foo page', 'id' => 1234567890 } }
    end
  end

end
