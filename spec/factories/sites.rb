# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
    name "MyString"
    description "MyText"
    address "MyString"
    suburb "MyString"
    latitude 1.5
    longitude 1.5
    size "9.99"
    water false
    available_until "2013-11-08"
    status "MyString"
  end
end
