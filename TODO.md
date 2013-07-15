# Models

* add state machine to every eventful model

# Events

* make sure handler supported_events can handle regexp
  - actually, just explicitly set supported events. there's not that many now, and won't be many more in the future.

# Hooks

- add default hooks to be included with all events
  - logging, metrics, etc. Anything that isn't user-specific
  - investigate using something other than hook-event handler system