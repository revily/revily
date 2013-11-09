# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :schedule do
    account
    name { "#{Forgery(:name).company_name} #{rand(1000) + 1}" }

    after(:stub) { |model| model.send(:ensure_uuid) }

    trait :with_alternate_time_zone do
      time_zone "EST"
    end

    trait :with_layers do
      ignore do
        rule "daily"
        users_count 2
        count 1
        layers_count 1
      end

      after(:stub) do |schedule, eval|
        schedule.schedule_layers = build_stubbed_list(:schedule_layer, eval.layers_count, schedule: schedule, rule: eval.rule, count: eval.count)
      end

      after(:create) do |schedule, evaluator|
        create(:schedule_layer, schedule: schedule, rule: evaluator.rule, count: evaluator.count)
      end
    end

    trait :with_layers_and_users do
      ignore do
        rule "daily"
        users_count 2
        count 1
      end

      after(:create) do |schedule, evaluator|
        create(:schedule_layer, :with_users, 
          schedule: schedule, 
          rule: evaluator.rule, 
          users_count: evaluator.users_count,
          count: evaluator.count
        )
      end
    end
  end
end
