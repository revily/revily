FactoryGirl.define do
  factory :account do
    subdomain { Forgery(:name).company_name.downcase }
  end
end
