# Design

This document defines the actions present within each section. Each section follows a particular structure: 

* a top-level section identifying the described resource
* sections for each route identifying available actions

    ```
    ## Foos 

    ### /foos
      - list foos
      - create a foo
      - link to foo
    ```

## Routes

/dashboard
/events
/services
/services/:id
/policies
/policies/:id
/schedules
/schedules/:id
/users
/users/:id
/hooks
/hooks/:id

## Wizard

- create a new user (already done?)
- add contact methods
- create a policy
  - add a policy rule with user
- create a service

## Dashboard

### /

- global state: banner at the top that identifies current health for all services
  at a glance
- open incidents

- all services?

## Incidents

### /incidents
- list of all incidents
- sorted by
  - service
  - state
  - created_at
- inline show incident

## Policies

## Services

### attributes

- name
- auto resolve timeout
- acknowledge timeout
- current health
- policy
- incidents count (triggered, acknowledged, resolved, total)
- state (enabled, disabled)

### /services

- list of services
  - show current health by color
  - incidents count (triggered, acknowledged, resolved, total)
- creating a new service
  - popdown or modal?
  - explain that a policy has to exist first
- managing services
  - edit name
  - changing policy
  - enable/disable (maintenance mode)
- events

### /services/:id
- current health
- go to incidents /services
- ack, resolve, escalate all incidents
- events
### /policies

- list policies
- go to show policy

### /policies/:id
- show policy
- all rules
- add new rule
- reorder rules
- events

## Schedules

### /schedules
- list schedules
  - timeline view
- go to show schedule
- events
### /schedules/:id
- show schedule
- list view
- calendar view
- events

## Users

### attributes

- name
- email
- authentication_token

### /users
- list users
- enable/disable
- show contact methods
- go to show user

### /users/:id
- show user
- contact methods
- api keys
- enable/disable/delete

