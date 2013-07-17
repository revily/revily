# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    association :source, factory: :service
    data "MyText"
    account
    event "MyString"
  end
end
