FactoryGirl.define do
  factory :user do
    account
    name { Forgery(:name).full_name }
    email { Forgery(:internet).email_address }
    password "asdfasdf"
    password_confirmation "asdfasdf"

    # authentication_token "asdfasdfasdfasdfasdfasdf"
    after(:stub) do |user|
      user.ensure_uuid
      user.send(:ensure_authentication_token)
    end
    
    factory :user_with_contacts do
      after(:create) do |user, evaluator|
        create(:email_contact, user: user)
        create(:phone_contact, user: user)
        create(:sms_contact, user: user)
      end
    end

    trait :dan_ryan do
      name "Dan Ryan"
      email "dan@appliedawesome.com"
      password "asdfasdf"
      password_confirmation "asdfasdf"
      
      after(:create) do |user|
        create(:sms_contact, user: user, address: "5172145853")
      end
    end
  end

end
