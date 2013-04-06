FactoryGirl.define do
  factory :user do
    account
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

    factory :dan_ryan do
      name "Dan Ryan"
      email "dan@appliedawesome.com"
      password "asdfasdf"
      password_confirmation "asdfasdf"
      
      after(:create) do |user|
        create(:sms_contact, contactable: user, address: "5172145853")
      end
    end
  end

end
