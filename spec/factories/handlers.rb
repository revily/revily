FactoryGirl.define do
  factory :handler do
    association :source, factory: :incident_with_service
    association :actor, factory: :user

    before(:build) do |handler|
      handler.actor.account = handler.source.account
    end

    factory :handler_campfire, class: Revily::Event::Handler::Campfire do
      event "incident.trigger"
    end

    factory :handler_incident_acknowledge, class: Revily::Event::Handler::IncidentAcknowledge do
      event "incident.acknowledge"
    end

    factory :handler_incident_trigger, class: Revily::Event::Handler::IncidentTrigger do
      event "incident.trigger"
    end

    factory :handler_incident_resolve, class: Revily::Event::Handler::IncidentResolve do
      event "incident.resolve"
    end

    factory :handler_log, class: Revily::Event::Handler::Log do
      event "incident.trigger"
    end

    factory :handler_null, class: Revily::Event::Handler::Null do
      event "incident.trigger"
    end

    factory :handler_web, class: Revily::Event::Handler::Web do
      event "incident.trigger"
    end

  end
end
