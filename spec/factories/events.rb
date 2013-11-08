# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    account
    association :source, factory: :service
    association :actor, factory: :user
    changeset { {} }
    action "created"

    after(:stub) { |model| model.ensure_uuid }
  end
end
