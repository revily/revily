FactoryGirl.define do
  factory :schedule_layer, aliases: [ :layer ] do
    schedule
    account { schedule && schedule.account }
    start_at { Time.zone.now }

    after(:stub) { |model| model.ensure_uuid }

    trait :hourly do
      rule "hourly"
      count 8
    end

    trait :daily do
      rule "daily"
    end

    trait :weekly do
      rule "weekly"
    end

    trait :monthly do
      rule "monthly"
    end

    trait :yearly do
      rule "yearly"
    end

    trait :with_users do
      rule "daily"

      ignore do
        users_count 2
      end

      after(:create) do |schedule_layer, evaluator|
        users = create_list(:user, evaluator.users_count, account: schedule_layer.schedule.account)
        users.each do |user|
          schedule_layer.users << user
        end
      end
    end

  end
end
