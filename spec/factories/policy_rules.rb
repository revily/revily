# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :policy_rule do
    policy
    account { policy && policy.account }
    escalation_timeout 1
    
    after(:build) do |rule|
      rule.set_assignment
      # rule.account = rule.policy.account
    end
    
    trait :for_user do
      association :assignment, factory: :user
    end

    trait :for_schedule do
      association :assignment, factory: [ :schedule, :with_layers_and_users ]
    end

    trait :for_dan_ryan do
      association :assignment, factory: [ :user, :dan_ryan ]
    end
    
  end
end
