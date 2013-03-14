# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email { Forgery(:internet).email_address }
    password "asdfasdf"
    password_confirmation "asdfasdf"

    factory :user_with_contacts do
      after(:create) do |user, evaluator|
        create(:email_contact, user: user)
        create(:phone_contact, user: user)
        create(:sms_contact, user: user)
      end
    end
  end

end
