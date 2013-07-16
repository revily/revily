# Models

* add state machine to every eventful model

# Events

* make sure handler supported_events can handle regexp
  - actually, just explicitly set supported events. there's not that many now, and won't be many more in the future.
  - add specs to handlers so we understand what they're doing and how they work.

#

# Hooks

- add default hooks to be included with all events
  - logging, metrics, etc. Anything that isn't user-specific
  - investigate using something other than hook-event handler system

# Incidents

- ensure incidents will not be fired unless the service's policy has rules
