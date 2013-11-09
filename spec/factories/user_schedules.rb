# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_schedule do
    schedule
    user

    after(:stub) { |model| model.send(:ensure_uuid) }

  end
end
