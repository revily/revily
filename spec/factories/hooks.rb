# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :hook do
    account
    
    name "Null Hook"
    handler "null"
    config Hash.new
    events { %w[ * ] }
    state "enabled"
    
    after(:stub) { |model| model.ensure_uuid }
  end

  trait :disabled do
    state "disabled"
  end

  trait :log do
    handler "log"
  end

  trait :null do
    handler "null"
  end

  trait :with_config do
    config { { "foo" => "bar", "baz" => "qux" } }
  end

  trait :for_incidents do
    events %w[ incident.* ]
  end

  trait :for_services do
    events %w[ service.created service.updated service.deleted ]
  end

  trait :specific_events do
    events %w[ incident.triggered service.updated policy.created ]
  end

  trait :all_events do
    events { Revily::Event.events }
  end

end
