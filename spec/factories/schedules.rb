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
      ignore do
        users []
        schedule_layer nil
      end

      before(:create) do |schedule, evaluator|
        # evaluator.users.concat create_list(:user, 2)
      end

      after(:create) do |schedule|
        schedule_layer = create(:schedule_layer, schedule: schedule, rule: 'daily')
        schedule_layer.users.concat create_list(:user, 2)
        # schedule_layer.users.concat create(:user, position: 3)
        # schedule_layer.users.concat create(:user, position: 1)
        # schedule_layer.users.concat create(:user, position: 2)
      end
    end
  end
end
