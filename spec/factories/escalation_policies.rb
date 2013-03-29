# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :escalation_policy do
    name "Operations"
    escalation_loop_limit 3
    
    factory :escalation_policy_with_rules do
      after(:create) do |escalation_policy|
        create(:escalation_rule_for_user, escalation_policy: escalation_policy)
        create(:escalation_rule_for_user, escalation_policy: escalation_policy)
        create(:escalation_rule_for_schedule, escalation_policy: escalation_policy)
      end
    end
  end
end
