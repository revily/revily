# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :schedule do
    name "MyString"
    timezone "MyString"
    rotation_type "MyString"
    start_at "2013-03-13 03:30:26"
  end
end
