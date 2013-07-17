# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_rule do
    account
    association :contact, factory: :email_contact

    factory :notification_rule_no_delay do
      start_delay 0
    end

    factory :notification_rule_five_minute_delay do
      start_delay 5
    end
  end
end
