FactoryGirl.define do
  factory :contact do
    user

    label "random label"

    after(:build) do |contact|
      contact.account = contact.user.account
    end

    factory :email_contact, class: EmailContact do
      address { Forgery(:internet).email_address }
    end

    factory :phone_contact, class: PhoneContact do
      address { Forgery(:address).phone }
    end

    factory :sms_contact, class: SmsContact do
      address { Forgery(:address).phone }
    end
  end
end
