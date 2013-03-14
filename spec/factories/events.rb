# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    message "Shit just got real."
    state "triggered"
    uuid "asdfasdfasdf"
  end
end
