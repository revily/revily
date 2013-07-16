# Models

* add state machine to every eventful model

# Events

* make sure handler supports_events can handle regexp
  - actually, just explicitly set supported events. there's not that many now, and won't be many more in the future.
  - add specs to handlers so we understand what they're doing and how they work.

* should we change event verbs to present tense? 
  - incident.resolve vs. incident.resolved

# Hooks

- add default hooks to be included with all events
  - logging, metrics, etc. Anything that isn't user-specific
  - investigate using something other than hook-event handler system

# Incidents

- ensure incidents will not be fired unless the service's policy has rules


# Document

user creates a hook with the name of a specific handler (incident_trigger)
  - hook is validated to ensure handler exists with hook.name
  - hook is validated to ensure hook.events are available to handler
incident receives :dispatch with the event 'incident.trigger'
  - sends event name (incident.trigger) and itself (Incident.new) as args to #dispatch
Event gathers list of user-created hooks and the default global hooks
  - iterates through each, creating a subscription object
  - subscription validates each hook and determines if hook is concerned about event
    - gets hook.events
    - matches event name("incident.trigger") with list of events hook cares about
      - if yes,
        - subscription notifies handler with event.name, source that published event, and hook.config
      - if no, subscription is skipped
handler checks to make sure it can handle things
  - handle? verifies necessary components are available
    - is the source valid?
    - does the config contain required data?
  - handler builds the payload (JSON) to send to Job
  - handler.notify runs #handle
    - handle typically schedules a Job to run
job is 


# Handler

match if
  - hook