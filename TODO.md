## Features

* add mail notifications
* add email parsing
* add flipper for setting features (https://github.com/jnunemaker/flipper)
* replace active_attr with virtus now that 1.0.0 has been released
* add the ability to route incidents based on predefined conditions. Examples:
  - a given service is not critical and should only send emails and not call
  - a given policy should call the engineers group but only email management
* allow policy rule to have multiple assignment groups: Examples:
  - different notification rules per group
  - first policy rule should notify both and engineers group and the current on-call
    - engineers group should only be emailed
    - current on-call should receive both a call and an SMS as well as email
  - a last resort policy 
    - if the primary and secondary fail to ack
    - call everyone in the engineers group
* move api namespace back to default / and...
* move ember app to /web namespace


* add oauth
  - rate limiting - https://github.com/applicake/doorkeeper/wiki/Rate-limit-with-Redis
  - admin superuser
    - customize tenancy to allow admin to get to any account

* add admin account
  - adding rails_admin support
  - routing constraints for /admin and /sidekiq

* add LDAP auth

## Refactor

* move voice and sms controllers to separate, mountable apps (grape? vanilla sinatra?)
  - part 1 done (moved to integration namespace)
* redo handlers
  - event list and matchers are very slow
* rewrite UserSchedule. look into caching values
* moar service objects! Look at travis-ci/travis-core for inspiration
* move notification logic out of contact classes

## Chores

* add missing specs:
  - event changeset
  - 
* sidekiq:
  - log job class

## Bugs

* warden trying password strategy twice (possibly related to default_scopes?)

# DONE

## Features
* add periscope for awesome custom filtering: https://github.com/laserlemon/periscope

## Refactors
* improve state machine code.

## Chores
* move concerns back to models/controllers
* removed eventable?, publishable?, etc. from Identifiable
