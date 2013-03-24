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

  end
end
