# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :escalation_policy do
    name "Operations"

    factory :escalation_policy_with_rules do
      after(:create) do |escalation_policy|
        create(:escalation_rule_for_user, escalation_policy: escalation_policy)
      end
    end
  end
end
