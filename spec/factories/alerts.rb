# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alert do
    event
    sent_at "2013-03-13 00:56:42"
  end
end
