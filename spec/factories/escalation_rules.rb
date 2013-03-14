# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :escalation_rule do
    escalation_policy
    escalation_timeout 1

    factory :escalation_rule_for_user do
      association :assignable, factory: :user
    end

    factory :escalation_rule_for_schedule do
      association :assignable, factory: :schedule
    end
  end
end
