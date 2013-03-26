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
      
      after(:create) do |schedule_layer|
        schedule_layer.users << create(:user)
        schedule_layer.users << create(:user)
      end
    end

  end
end
