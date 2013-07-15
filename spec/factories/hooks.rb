# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :hook do
    account
    
    name 'test'
    config Hash.new
    events []
    active true
    
    after(:stub) do |hook|
      hook.ensure_uuid
    end
  end

  trait :inactive do
    active false
  end

  trait :log do
    name 'log'
  end

  trait :for_incidents do
    events %w[ incident.triggered incident.acknowledged incident.resolved ]
  end
# 
  trait :for_services do
    events %w[ service.created service.updated service.deleted ]
  end

  trait :test do
    name 'test'
  end
end
