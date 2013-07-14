# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :hook do
    name "MyString"
    config "MyText"
    events "MyText"
    active false
  end
end
