# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service do
    name "Application"
    auto_resolve_timeout 240
    acknowledge_timeout 30

    escalation_policy

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
  end
end
