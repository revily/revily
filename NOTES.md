# WORKFLOW

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



# SCHEDULES

schedule.new -> schedule_layer


user_schedule_layer


[11] pry(main)> sb.start_s.schedule
sb.start_date   sb.start_date=  sb.start_time   sb.start_time=
[11] pry(main)> sb.start_s.schedule
sb.start_date   sb.start_date=  sb.start_time   sb.start_time=
[11] pry(main)> sb.start_time = s.schedule.start_at