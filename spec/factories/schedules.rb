# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :schedule do
    name "Operations"
    # time_zone "MyString"
    start_at { Time.zone.now }

    factory :schedule_with_alternate_time_zone do
      time_zone "EST"
    end

    factory :schedule_with_layers do
      after(:create) do |schedule|
        create(:schedule_layer, schedule: schedule, rule: 'daily')
      end
    end

    factory :schedule_with_layers_and_users do
      after(:create) do |schedule|
        create(:schedule_layer_with_users, schedule: schedule, rule: 'daily')
      end
    end
  end
end
