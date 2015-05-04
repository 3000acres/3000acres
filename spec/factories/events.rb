# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event, class:Hash do
    id 11
    name "Test"
    cover_source"http://some_image.com/image"
    place_name "Some Community Garden"
    city "Brunswick"
    street "33 James st"
    start_time "2015-05-01T14:30:00+1000"
    end_time "2015-05-01T16:00:00+1000"
    description "Test description"

    initialize_with { 
      { 
        "id"=> id, 
        "name"=> name,
        "cover"=>{
          "source"=> cover_source, 
        }, 
        "place"=> {
          "name"=> place_name,
          "location"=> {
            "city"=> city,
            "street"=> street,
          },
        },
        "description"=> description,
        "start_time"=> start_time,
        "end_time"=> end_time
      } 
    }
  end
end
