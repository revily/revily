# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :schedule_layer do
    schedule
    start_at "2013-03-23 04:43:31"

    factory :daily_schedule_layer do
      type 'daily'
    end

    factory :weekly_schedule_layer do
      type 'weekly'
    end

    factory :custom_schedule_layer do
      type 'custom'
      count 8
      unit 'hours'
    end

  end
end
