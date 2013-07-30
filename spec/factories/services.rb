# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service do
    account
    policy
    name { "#{Forgery(:name).company_name} #{rand(1000) + 1}" }
    auto_resolve_timeout 240
    acknowledge_timeout 30

    trait :with_policy do
      association :policy, factory: [ :policy, :with_rules ]
    end

    trait :with_incidents do
      ignore do
        incidents_count 10
      end

      after(:create) do |service, evaluator|
        create_list(:incident, evaluator.incidents_count, :with_random_state, service: service)
      end
    end

    trait :enabled do
      state "enabled"
    end

    trait :disabled do
      state "disabled"
    end

  end
end
