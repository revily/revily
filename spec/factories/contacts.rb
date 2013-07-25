FactoryGirl.define do
  factory :contact do
    association :contactable, factory: :user
    account { contactable.account }
    # after(:build, :stub) do |contact|
      # contact.account = contact.contactable.account
    # end
    label "random label"

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
