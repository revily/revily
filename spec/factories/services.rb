# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service do
    name "Application"
    auto_resolve_timeout 240
    acknowledgement_timeout 30

    state "enabled"
    escalation_policy
  end
end
