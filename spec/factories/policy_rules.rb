# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :policy_rule do
    policy
    escalation_timeout 1

    trait :for_user do
      association :assignable, factory: :user
    end

    trait :for_schedule do
      association :assignable, factory: [ :schedule, :with_layers_and_users ]
    end

    trait :for_dan_ryan do
      association :assignable, factory: [ :user, :dan_ryan ]
    end
    
  end
end
