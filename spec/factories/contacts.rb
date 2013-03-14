# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    # user nil
    label "MyString"
    address "MyString"
    uuid { SecureRandom.uuid }

    factory :email_contact do
      type "email"
      address { Forgery(:internet).email_address }
    end

    factory :phone_contact do
      type "phone"
      address { Forgery(:address).phone }
    end

    factory :sms_contact do
      type "sms"
      address { Forgery(:address).phone }
    end
  end
end
