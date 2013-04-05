# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    service
    message { Forgery(:lorem_ipsum).words(5) }

    trait :key do
      key "app1.example.com/load_average"
    end

    trait :with_random_state do
      state { %w[ triggered acknowledged resolved ].sample }
    end

    factory :acknowledged_event do
      state "acknowledged"
    end

    factory :resolved_event do
      state "resolved"
    end

    factory :event_with_key, traits: [ :key ]
    
    factory :event_with_service, traits: [ :key ] do
      association :service, :with_escalation_policy
    end

  end
end
