FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@example.com" }
  sequence(:name) { |n| "user#{n}" }

  factory :user do
    name { generate(:name) }
    email { generate(:email) }
    password 'changeme'
    password_confirmation 'changeme'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now

    factory :admin_user do
      roles { [ FactoryGirl.create(:admin) ] }
    end
  end

end
