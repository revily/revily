# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :escalation_policy do
    name "Operations"

    factory :escalation_policy_with_rules do
      after(:create) do |escalation_policy|
        create(:email_contact, user: user)
        create(:phone_contact, user: user)
        create(:sms_contact, user: user)
      end
    end
  end
end
