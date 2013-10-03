FactoryGirl.define do
  factory :handler_incident_trigger, class: Revily::Event::Handler::IncidentTrigger do
    event 'incident.trigger'
    association :source, factory: :incident
    association :actor, factory: :user
  end
end