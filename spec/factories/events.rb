# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    service
    message "Shit just got real."
    state "triggered"
  end
end
