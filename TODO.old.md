lol

# Controllers

* add routes:
  - users/:id/schedules
  - users/:id/incidents
  - users/:id/assignments
  - users/:id/contacts

# Models

* test to make sure deleting a user won't delete a schedule and vice versa
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
incident receives :dispatch with the event 'incident.triggered'
  - sends event name (incident.triggered) and itself (Incident.new) as args to #dispatch
Event gathers list of user-created hooks and the default global hooks
  - iterates through each, creating a subscription object
  - subscription validates each hook and determines if hook is concerned about event
    - gets hook.events
    - matches event name("incident.triggered") with list of events hook cares about
      - if event is 'incident.triggered'
        - each hook will determine:
          - if hook.events contains 'incident.triggered'
            - then notify handler
          - if hook.events does not contain 'incident.triggered'
            - then do not notify handler
      - validation is also performed by the handler on hook creation. hooks cannot be created for handlers that do not support the configured events
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

## matches

hooks are a way to funnel events externally
if a hook:
  - events: [ * ]
  - all events will trigger this hook to be dispatched to a handler
    - if a handler doesn't support a hook,


match if
  - hook