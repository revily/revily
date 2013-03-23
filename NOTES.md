# Workflow of an event

* Event is created
* look up 


# Setup

* create user
* create schedule
  * create schedule layers
    - assign to user
* create escalation policy
  * create escalation rule
    - assign to schedule
    - assign to user
* create service
  - assign to escalation policy



## ALL ROTATIONS ARE CALCULATED IN SECONDS

rotation_in_seconds
  daily = 24 * 60 60 
  weekly = daily * 7
  custom = shift_length * shift_unit

  shift_units
    hours = 60 * 60
    days = hours * 24 * shift_length
    weeks = days * 7 * shift_length