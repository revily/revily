# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name { Forgery(:name).full_name }
    email { Forgery(:internet).email_address }
    password "asdfasdf"
    password_confirmation "asdfasdf"

    factory :user_with_contacts do
      after(:create) do |user, evaluator|
        create(:email_contact, contactable: user)
        create(:phone_contact, contactable: user)
        create(:sms_contact, contactable: user)
      end
    end

    factory :complex do
      ignore do
        users []
      end

      before(:create) do |schedule|
        create(:user)
      end
      after(:create) do |schedule|

      end
    end
  end

end
