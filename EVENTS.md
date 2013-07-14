event: fired by state transition

## Example of event payload

## Flow
event is dispatched to subscribers
   - call #notify for each subscription
    - pass event payload to subscription

every subscription has a #notify method that will do the right thing
- subscription subclasses from base subscription class; override #notify method in each subclass