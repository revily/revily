# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :schedule_layer do
    schedule
    start_at { Time.zone.now }

    factory :daily_schedule_layer do
      rule 'daily'
    end

    factory :weekly_schedule_layer do
      rule 'weekly'
    end

    factory :hourly_schedule_layer do
      rule 'hourly'
      count 8
    end

    factory :schedule_layer_with_users do
      rule 'daily'

      ignore do
        users_count 2
      end
      
      after(:create) do |schedule_layer, evaluator|
        users = create_list(:user, evaluator.users_count)
        users.each do |user|
          schedule_layer.users << user
        end
      end
    end

  end
end
