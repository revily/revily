# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :escalation_rule do
    escalation_policy
    escalation_timeout 1

    factory :escalation_rule_for_user do
      association :assignable, factory: :user
    end

    factory :escalation_rule_for_schedule do
      association :assignable, factory: :schedule_with_layers_and_users
    end

    factory :rule_for_dan_ryan do
      association :assignable, factory: :dan_ryan
    end
    
  end
end
