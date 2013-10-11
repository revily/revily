FactoryGirl.define do
  factory :application, class: Doorkeeper::Application do
    name { "#{Forgery(:name).company_name} #{rand(1000) + 1}" }
    redirect_uri "urn:ietf:wg:oauth:2.0:oob"
  end
end