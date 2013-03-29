# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service do
    name { Forgery(:name).company_name }
    auto_resolve_timeout 240
    acknowledge_timeout 30

    escalation_policy

    trait :with_escalation_policy do
      association :escalation_policy, factory: :escalation_policy_with_rules
    end

    factory :enabled_service do
      state "enabled"
    end

    factory :disabled_service do
      state "disabled"
    end

    factory :service_with_events do
      after(:create) do |service|
        create(:event, service: service)
      end
    end

    factory :service_with_escalation_policy, traits: [ :with_escalation_policy ]
  end
end
