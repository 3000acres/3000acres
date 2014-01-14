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

    factory :invalid_user_shortname do
      name 'a'
    end

    factory :invalid_user_longname do
      name 'MarmadukeBlundellHollinsheadBlundellTolemachePlantagenetWhistlebinkie3rdDukeofMarmoset'
    end

    factory :invalid_user_spaces do
      name "a b"
    end

    factory :invalid_user_badchars do
      name 'aa%$'
    end

    factory :invalid_user_badname do
      name 'admin'
    end

    factory :valid_user_alphanumeric do
      name 'abc123'
    end

    factory :valid_user_uppercase do
      name 'ABC123'
    end

    factory :valid_user_underscore do
      name 'abc_123'
    end

  end

end
