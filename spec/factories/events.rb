# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    source nil
    data "MyText"
    account nil
    event "MyString"
  end
end
