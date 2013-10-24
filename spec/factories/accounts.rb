FactoryGirl.define do
  factory :account do
    name { "#{Forgery(:name).company_name} #{rand(1000) + 1}" }
  end
end
