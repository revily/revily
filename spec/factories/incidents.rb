# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :incident do
    service
    message { Forgery(:lorem_ipsum).words(5) }

    trait :key do
      key "app1.example.com/load_average"
    end

    trait :with_random_state do
      state { %w[ triggered acknowledged resolved ].sample }
    end

    trait :acknowledged do
      state "acknowledged"
    end

    trait :resolved do
      state "resolved"
    end

    factory :incident_with_key, traits: [ :key ]
    
    factory :incident_with_service, traits: [ :key ] do
      association :service, :with_policy
    end

  end
end
