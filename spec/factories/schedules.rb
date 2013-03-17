# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :schedule do
    name "Operations"
    # time_zone "MyString"
    start_at { Time.zone.now }

    factory :daily_schedule do
      rotation_type 'daily'
    end

    factory :weekly_schedule do
      rotation_type 'weekly'
    end

    factory :custom_schedule do
      rotation_type 'custom'
      shift_length 8
      shift_length_unit 'hours'
    end

    factory :schedule_with_alternate_time_zone do
      time_zone "EST"
    end
  end
end
