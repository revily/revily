# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription, class: Revily::Event::Subscription do
    name "null" # handler name
    event "incident.triggered"
    config { {} }

    after(:stub) do |subscription|
      account = build_stubbed(:account)
      subscription.source = build_stubbed(:incident, account: account)
      subscription.actor = build_stubbed(:user, account: account)
    end
  end
end
