# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
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
  end
end
